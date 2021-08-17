from genericpath import isfile
import subprocess
from typing import final
import PySimpleGUI as sg
import os
import pyqrcode
import png
from pyqrcode import QRCode
import socket
from random import randint
from multiprocessing import Process
from threading import Thread, Lock
import pyautogui
from flask import Flask
from flask_restful import Resource, Api, reqparse
import pandas as pd
import pyautogui
import secrets
import sys
import time

app = Flask(__name__)
api = Api(app)

mutex = Lock()

_secret = None
_currentCommand = None

port = 8000
hostname = socket.gethostname()
local_ip = socket.gethostbyname(hostname)

pin = randint(1000, 9999)

s = "http://" + local_ip + ":"+str(port) + '\n' + str(pin)
url = pyqrcode.create(s)
url.png('qrcode.png', scale=8)

flask = None


def criticalFunction(function, args):
    mutex.acquire()
    try:
        function(args)
    finally:
        mutex.release()


class Commands(Resource):
    def _useControl(self, args):
        global _currentCommand
        print(args)
        new_key = str(args['command'])
        mode = str(args['mode'])
        if(_currentCommand != None):
            pyautogui.keyUp(_currentCommand)
            _currentCommand = None
        if(mode == 'keep'):
            pyautogui.keyDown(new_key)
            _currentCommand = new_key
        elif(mode == 'leave'):
            self._currentCommand = None
            pyautogui.keyUp(new_key)
        elif(mode == 'tap'):
            commands = new_key.split('+')
            if(len(commands) > 1):
                pyautogui.hotkey(commands[0], commands[1])
            else:
                if(new_key == "click"):
                    pyautogui.click()
                else:
                    pyautogui.press(new_key)

    def put(self):
        # try:
        parser = reqparse.RequestParser()  # initialize
        parser.add_argument('command', required=True)  # add arguments
        parser.add_argument('mode', required=True)
        parser.add_argument('token', required=True)
        args = parser.parse_args()
        token = str(args['token'])
        if(token != _secret):
            return {}, 403
        criticalFunction(self._useControl, args)
        return {}, 204

    def post(self):
        parser = reqparse.RequestParser()  # initialize
        parser.add_argument('pin', required=True)  # add arguments
        args = parser.parse_args()
        client_pin = args['pin']
        if(str(pin) != str(client_pin)):
            return {}, 403
        global _secret
        _secret = secrets.token_hex(16)
        with open(".secret.env", "w") as f:
            f.write(_secret)
        return {'token': _secret}, 200


api.add_resource(Commands, '/command')  # POST to pair and PUT to press a key


def call_flask():
    app.run(local_ip, port=port)


# Interface
layout = [
    [
        sg.Text("Welcome to the Wireless Game Pad project"),
    ],
    [
        sg.Text(
            "To connect your device you need to read that QrCode in the app", key="main"),
    ],
    [
        sg.Image(filename=os.getcwd()+'/qrcode.png', key='-IMAGE-')
    ],
    [
        sg.Text("Developer: Leon Tenório da Silva"),
    ],
]

window = sg.Window(title="Wirelesse Controller - Computer Client",
                   layout=layout, margins=(100, 50), finalize=True)

# Thread to run the flask app
apiThread = Process(target=call_flask)
apiThread.start()

# Loop to execute the interface
while True:
    event, values = window.read(timeout=10)
    if(os.path.isfile('.secret.env')):
        with open(".secret.env", "r") as f:
            window['main'].Update('Connected')
    if event == "OK" or event == sg.WIN_CLOSED:
        break
    time.sleep(1)

# Close app
window.close()  # Close window
if(_currentCommand != None):
    # If we have a current command, unpress that key
    pyautogui.keyUp(_currentCommand)
os.remove(".secret.env")  # Remove the secret token file
apiThread.kill()  # Close the flask app

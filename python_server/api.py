from threading import Thread, Lock
import pyautogui
from flask import Flask
from flask_restful import Resource, Api, reqparse
import pandas as pd
import pyautogui
import secrets
import sys

app = Flask(__name__)
api = Api(app)

mutex = Lock()

_secret = None
_currentCommand = None

pin = None


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
        return {'token': _secret}, 200


api.add_resource(Commands, '/command')

pin = int(sys.argv[3])
app.run(sys.argv[1], port=int(sys.argv[2]))  # run our Flask app

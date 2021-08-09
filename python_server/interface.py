import subprocess
import PySimpleGUI as sg
import os
import pyqrcode
import png
from pyqrcode import QRCode
import socket
from random import randint

port = 8000
hostname = socket.gethostname()
local_ip = socket.gethostbyname(hostname)

pin = randint(1000, 9999)

s = "http://" + local_ip + ":"+str(port) + '\n' + str(pin)
url = pyqrcode.create(s)
url.png('qrcode.png', scale=8)

flask = None


def call_flask(address, port, pin):
    global flask
    flask = subprocess.Popen(
        "python api.py "+str(address)+" "+str(port)+' '+str(pin), shell=True)


def cancel_flask():
    if(flask != None):
        flask.kill()


layout = [
    [
        sg.Text("Welcome to the Wireless Game Pad project"),
    ],
    [
        sg.Text("To connect your device you need to read that QrCode in the app"),
    ],
    [
        sg.Image(filename=os.getcwd()+'/qrcode.png', key='-IMAGE-')
    ],
    [
        sg.Text("Developer: Leon Tenório da Silva"),
    ],
]

window = sg.Window(title="Wirelesse Controller - Computer Client",
                   layout=layout, margins=(100, 50))

call_flask(local_ip, port, pin)
window.read()

window.close()
cancel_flask()

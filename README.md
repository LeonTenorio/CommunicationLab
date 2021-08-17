## Wireless Flutter GamePad

Student: Leon Tenório da Silva
Comunnication Laboratory 1S2021 UNIFESP

That is a undergraduation project using Flutter and Python to create a Wireless GamePad using the localhost address.

In the python implementation [python server](python_server/interface.py) we have the computer client server side. That client has a basic interface implemented using [PySimpleGui](https://pysimplegui.readthedocs.io/en/latest/) to show the paring QRCode created with [PyQRCode](https://pythonhosted.org/PyQRCode/) with the generated PIN, currenct ip address and the port to acess and pair the gamepad with the controled machine. The http interface is used to provide that communication and I used [Flask](https://flask.palletsprojects.com/en/2.0.x/) in that implementation.

The mobile side has been implemented using [Flutter](https://flutter.dev/) with standart libraries like http, to read the QRCode I used [QR Code Scanner](https://pub.dev/packages/qr_code_scanner) and to store some pad commands I used [Shared Preferences](https://pub.dev/packages/shared_preferences). We can see that implementation inside the [game_controller](game_controller) folder.

Finnaly, if you want to use that application you will need to run the [interface.py](python_server/interface.py) with the necessary libs (you can use the [requirements.txt](python_server/requirements.txt) to install it), put in you smartphone the [Flutter app](game_controller), read the generated QRCode in the app, open a game and enjoy it.

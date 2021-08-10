import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_controller/api/control.dart' as api;
import 'package:game_controller/screens/control.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ReadedValues {
  String ip;
  String port;
  String pin;
  ReadedValues({required this.ip, required this.port, required this.pin});
}

class PairScreen extends StatefulWidget {
  const PairScreen({Key? key}) : super(key: key);

  @override
  _PairScreenState createState() => _PairScreenState();
}

class _PairScreenState extends State<PairScreen> {
  Barcode? result;
  QRViewController? controller;
  GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown]);
    super.initState();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    qrKey = GlobalKey(debugLabel: 'QR');
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown]);
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  ReadedValues? _extractQrCodeInformations() {
    try {
      List<String> lines = (this.result as Barcode).code.split("\n");
      String ip = lines[0].split(":")[0] + ":" + lines[0].split(":")[1];
      String port = lines[0].split(":")[2];
      return ReadedValues(ip: ip, port: port, pin: lines[1]);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Container(
            width: MediaQuery.of(context).size.width,
            child: result != null
                ? Card(
                    child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Text("IP: " + this._extractQrCodeInformations()!.ip),
                        Text(
                            "Port: " + this._extractQrCodeInformations()!.port),
                        Text("Pin: " + this._extractQrCodeInformations()!.pin),
                        TextButton(
                          child: Text("Pair"),
                          onPressed: () async {
                            ReadedValues? values =
                                this._extractQrCodeInformations();
                            if (values != null) {
                              bool success = await api.auth(
                                  values.ip + ":" + values.port, values.pin);
                              if (success) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GamePad()),
                                    (route) => false);
                              }
                            }
                          },
                        )
                      ],
                    ),
                  ))
                : Container(),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 600 ||
            MediaQuery.of(context).size.height < 600)
        ? 300.0
        : 600.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        qrKey = GlobalKey(debugLabel: 'QR');
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller!.pauseCamera();
    controller?.dispose();
    super.dispose();
  }
}

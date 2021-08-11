import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_controller/api/control.dart';
import 'package:game_controller/screens/pair.dart';
import 'package:game_controller/widgets/button.dart';

final int pingSecondsTime = 2;

class GamePad extends StatefulWidget {
  GamePad({Key? key}) : super(key: key);

  @override
  _GamePadState createState() => _GamePadState();
}

class _GamePadState extends State<GamePad> {
  UniqueKey upButtonKey = UniqueKey();
  UniqueKey downButtonKey = UniqueKey();
  UniqueKey leftButtonKey = UniqueKey();
  UniqueKey rightButtonKey = UniqueKey();

  UniqueKey triangleButtonKey = UniqueKey();
  UniqueKey circleButtonKey = UniqueKey();
  UniqueKey squareButtonKey = UniqueKey();
  UniqueKey exButtonKey = UniqueKey();

  UniqueKey pauseButtonKey = UniqueKey();
  UniqueKey playButtonKey = UniqueKey();
  UniqueKey restartButtonKey = UniqueKey();

  FocusNode _focusNode = FocusNode();

  bool config = false;

  TextEditingController? textEditingController;
  WidgetSetActionFunction? saveButtonEdition;

  int ping = 999;
  Timer? pingTimer;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.initState();
    this.pingTimer =
        Timer.periodic(Duration(seconds: pingSecondsTime), (timer) {
      this.ping = getPing();
      if (this.mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    this.pingTimer!.cancel();
    super.dispose();
  }

  void _resetButtons() {
    this.upButtonKey = UniqueKey();
    this.downButtonKey = UniqueKey();
    this.leftButtonKey = UniqueKey();
    this.rightButtonKey = UniqueKey();

    this.triangleButtonKey = UniqueKey();
    this.circleButtonKey = UniqueKey();
    this.squareButtonKey = UniqueKey();
    this.exButtonKey = UniqueKey();

    this.pauseButtonKey = UniqueKey();
    this.playButtonKey = UniqueKey();
    this.restartButtonKey = UniqueKey();

    textEditingController = null;
    saveButtonEdition = null;
  }

  void resetButtons() {
    this._resetButtons();
    setState(() {});
  }

  void callbackConfig(String? value, WidgetSetActionFunction saveFunction) {
    if (this.saveButtonEdition != null && this.textEditingController != null) {
      String? editedValue =
          (this.textEditingController as TextEditingController).text;
      if (editedValue.length == 0) editedValue = null;
      (this.saveButtonEdition as Function)(editedValue);
    }
    this.setState(() {
      this.textEditingController = new TextEditingController(text: value);
      this.saveButtonEdition = saveFunction;
    });
  }

  void doneEdition() {
    if (this.saveButtonEdition != null && this.textEditingController != null) {
      String? editedValue =
          (this.textEditingController as TextEditingController).text;
      if (editedValue.length == 0) editedValue = null;
      (this.saveButtonEdition as Function)(editedValue);
    }
    setState(() {
      this.saveButtonEdition = null;
      this.textEditingController = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 40, left: 20.0),
              child: Text(ping.toString() + "ms"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 110.0,
                      backgroundColor: Colors.white38,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ControlButton(
                            callbackConfig: callbackConfig,
                            configMode: this.config,
                            key: upButtonKey,
                            iconData: Icons.arrow_upward,
                            action: "up",
                          ),
                          SizedBox(
                            height: 1.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ControlButton(
                                callbackConfig: callbackConfig,
                                configMode: this.config,
                                key: leftButtonKey,
                                iconData: Icons.arrow_back,
                                action: "left",
                              ),
                              SizedBox(
                                width: 52.0,
                              ),
                              ControlButton(
                                callbackConfig: callbackConfig,
                                configMode: this.config,
                                key: rightButtonKey,
                                iconData: Icons.arrow_forward,
                                action: "right",
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.0,
                          ),
                          ControlButton(
                            callbackConfig: callbackConfig,
                            configMode: this.config,
                            key: downButtonKey,
                            iconData: Icons.arrow_downward,
                            action: "down",
                          ),
                        ],
                      ),
                    )),
                SizedBox(
                  width: 50.0,
                ),
                Container(
                  padding: EdgeInsets.only(top: 100.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ControlButton(
                        key: pauseButtonKey,
                        callbackConfig: callbackConfig,
                        configMode: this.config,
                        iconData: Icons.pause,
                        action: "alt+key",
                        onPressed: this.resetButtons,
                        disableLongPress: true,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      ControlButton(
                        key: playButtonKey,
                        callbackConfig: callbackConfig,
                        configMode: this.config,
                        iconData: Icons.play_arrow,
                        action: "click",
                        onPressed: this.resetButtons,
                        disableLongPress: true,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      ControlButton(
                        key: restartButtonKey,
                        callbackConfig: callbackConfig,
                        configMode: this.config,
                        iconData: Icons.refresh,
                        action: "f5",
                        onPressed: this.resetButtons,
                        disableLongPress: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 50.0,
                ),
                Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 110.0,
                      backgroundColor: Colors.white38,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ControlButton(
                            callbackConfig: callbackConfig,
                            configMode: this.config,
                            key: triangleButtonKey,
                            iconData: Icons.change_history,
                          ),
                          SizedBox(
                            height: 1.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ControlButton(
                                callbackConfig: callbackConfig,
                                configMode: this.config,
                                key: squareButtonKey,
                                iconData: Icons.crop_din,
                              ),
                              SizedBox(
                                width: 52.0,
                              ),
                              ControlButton(
                                callbackConfig: callbackConfig,
                                configMode: this.config,
                                key: circleButtonKey,
                                iconData: Icons.circle,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.0,
                          ),
                          ControlButton(
                            callbackConfig: callbackConfig,
                            configMode: this.config,
                            key: exButtonKey,
                            iconData: Icons.close,
                          ),
                        ],
                      ),
                    )),
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                child: Text(
                  "Exit",
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => PairScreen()),
                      (route) => false);
                },
              ),
            ),
            this.config
                ? Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: 50.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextFormField(
                        focusNode: _focusNode,
                        controller: this.textEditingController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter the key actions'),
                        onEditingComplete: () {
                          _focusNode.unfocus();
                          this.doneEdition();
                        },
                      ),
                    ))
                : Container(),
            this.config
                ? Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(right: 20.0, top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            this.resetButtons();
                            setState(() {
                              config = false;
                            });
                          },
                        ),
                        TextButton(
                          child: Text("Save"),
                          onPressed: () {
                            this.doneEdition();
                            this.resetButtons();
                            setState(() {
                              config = false;
                            });
                          },
                        )
                      ],
                    ))
                : Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(right: 20.0, top: 20.0),
                    child: IconButton(
                      iconSize: 35.0,
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        this.resetButtons();
                        setState(() {
                          config = true;
                        });
                      },
                    ),
                  )
          ],
        ));
  }
}

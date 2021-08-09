import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_controller/widgets/button.dart';

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

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.initState();
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
  }

  void resetButtons() {
    this._resetButtons();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
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
                        key: leftButtonKey,
                        iconData: Icons.arrow_back,
                        action: "left",
                      ),
                      SizedBox(
                        width: 52.0,
                      ),
                      ControlButton(
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
                iconData: Icons.pause,
                action: "alt+key",
                onPressed: this.resetButtons,
                disableLongPress: true,
              ),
              SizedBox(
                width: 10.0,
              ),
              ControlButton(
                iconData: Icons.play_arrow,
                action: "click",
                onPressed: this.resetButtons,
                disableLongPress: true,
              ),
              SizedBox(
                width: 10.0,
              ),
              ControlButton(
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
                        key: squareButtonKey,
                        iconData: Icons.crop_din,
                      ),
                      SizedBox(
                        width: 52.0,
                      ),
                      ControlButton(
                        key: circleButtonKey,
                        iconData: Icons.circle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.0,
                  ),
                  ControlButton(
                    key: exButtonKey,
                    iconData: Icons.close,
                  ),
                ],
              ),
            )),
      ],
    ));
  }
}

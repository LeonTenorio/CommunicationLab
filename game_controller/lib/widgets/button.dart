import 'package:flutter/material.dart';
import 'package:game_controller/api/control.dart' as api;

class ControlButton extends StatefulWidget {
  IconData iconData;
  double? size;
  String? action;
  bool? disableLongPress;
  Function? onPressed;
  ControlButton(
      {Key? key,
      required this.iconData,
      this.action,
      this.size,
      this.disableLongPress,
      this.onPressed})
      : super(key: key);

  @override
  _ControlButtonState createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Opacity(
          opacity: this.widget.action != null ? 1.0 : 0.7,
          child: Card(
              color: this.pressed ? Colors.black : null,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  this.widget.iconData,
                  color: this.pressed ? Colors.white38 : Colors.white,
                  size: this.widget.size != null ? this.widget.size : 50.0,
                ),
              ))),
      onTapDown: (_) {
        if (this.widget.action != null) {
          String action = this.widget.action as String;
          setState(() {
            this.pressed = true;
          });

          api.Action buttonAction = api.Action.press;
          if (this.widget.disableLongPress != null &&
              this.widget.disableLongPress == true) {
            buttonAction = api.Action.tap;
          }

          api.pressButton(
              api.ButtonParams(button: action, action: buttonAction));
        }
        if (this.widget.onPressed != null) {
          Function pressed = this.widget.onPressed as Function;
          pressed();
        }
      },
      onTapUp: (_) {
        if (this.widget.action != null) {
          String action = this.widget.action as String;
          setState(() {
            this.pressed = false;
          });

          if (this.widget.disableLongPress == null ||
              this.widget.disableLongPress == false) {
            api.Action buttonAction = api.Action.unPress;
            api.pressButton(
                api.ButtonParams(button: action, action: buttonAction));
          }
        }
      },
    );
  }
}

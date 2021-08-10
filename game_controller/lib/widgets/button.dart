import 'package:flutter/material.dart';
import 'package:game_controller/api/control.dart' as api;
import 'package:shared_preferences/shared_preferences.dart';

typedef void WidgetSetActionFunction(String? action);
typedef void CallBackFunction(
    String? value, WidgetSetActionFunction saveFunction);

class ControlButton extends StatefulWidget {
  IconData iconData;
  double? size;
  String? action;
  bool? disableLongPress;
  Function? onPressed;
  bool configMode;
  CallBackFunction callbackConfig;
  ControlButton(
      {Key? key,
      required this.iconData,
      required this.configMode,
      this.action,
      this.size,
      this.disableLongPress,
      this.onPressed,
      required this.callbackConfig})
      : super(key: key);

  @override
  _ControlButtonState createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  bool pressed = false;

  @override
  void initState() {
    super.initState();
    _getActualAction();
  }

  String _getCacheRef() {
    return this.widget.iconData.codePoint.toString();
  }

  Future<void> _getActualAction() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    String? actualValue = ref.getString(this._getCacheRef());
    if (actualValue != null) {
      setState(() {
        this.widget.action = actualValue;
      });
    }
  }

  Future<void> _setNewAction(String? action) async {
    print("close button edition");
    if (action != null) print(action);
    setState(() {
      pressed = false;
      this.widget.action = action;
    });
    SharedPreferences ref = await SharedPreferences.getInstance();
    if (action != null) {
      await ref.setString(this._getCacheRef(), action);
    } else {
      await ref.remove(this._getCacheRef());
    }
  }

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
        setState(() {
          this.pressed = true;
        });
        if (this.widget.configMode) {
          this.widget.callbackConfig(this.widget.action, this._setNewAction);
        } else {
          if (this.widget.action != null) {
            String action = this.widget.action as String;

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
        }
      },
      onTapUp: (_) {
        if (!this.widget.configMode) {
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
        }
      },
    );
  }
}

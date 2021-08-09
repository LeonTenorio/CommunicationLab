import 'dart:convert';

import 'package:http/http.dart';

String url = 'http://192.168.1.13:8000';

Client client = Client();

String token = "";

enum Action {
  tap,
  press,
  unPress,
}

class ButtonParams {
  String button;
  Action action;
  ButtonParams({required this.button, required this.action});
}

Future<void> pressButton(ButtonParams params) async {
  Response response = await client.put(Uri.parse(url + '/command'), body: {
    'token': token,
    'command': params.button,
    'mode': params.action == Action.press
        ? 'keep'
        : params.action == Action.unPress
            ? 'leave'
            : 'tap'
  });
}

Future<bool> auth(String hostUrl, String pin) async {
  try {
    print('tryng to pair ' + hostUrl);
    url = hostUrl;
    Response response =
        await client.post(Uri.parse(url + '/command'), body: {'pin': pin});
    print('tryng to pair ' + response.body);
    token = json.decode(response.body)['token'] as String;
    return true;
  } catch (e) {
    print('tryng to pair ' + e.toString());
    return false;
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_controller/screens/control.dart';
import 'package:game_controller/screens/pair.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
  //     .then((_) {
  runApp(MyApp());
  // });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
        textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 18.0),
          bodyText2: TextStyle(fontSize: 16.0),
          button: TextStyle(fontSize: 16.0),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: PairScreen(),
    );
  }
}

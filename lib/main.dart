import 'package:flutter/material.dart'
    show
        Brightness,
        BuildContext,
        Colors,
        MaterialApp,
        StatelessWidget,
        ThemeData,
        Widget,
        runApp;
import 'package:loginsystem/screen/login.dart';
import 'package:loginsystem/screen/register.dart';
import 'package:loginsystem/screen/add.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          brightness: Brightness.light,
        ),
        home: LoginScreen());
  }
}

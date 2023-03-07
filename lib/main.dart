import 'dart:ui';

import 'package:flutter/material.dart';

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
        title: 'Market',
        theme: ThemeData(
            primarySwatch: Colors.lightGreen, brightness: Brightness.light),
        home: LoginScreen());
  }
}

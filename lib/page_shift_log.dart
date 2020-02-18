import 'package:flutter/material.dart';

class ShiftLogPage extends StatefulWidget {
  String title = 'Shift Log';

  ShiftLogPage({Key key, title}) : super(key: key);

  @override
  _ShiftLogPageState createState() => _ShiftLogPageState();
}

class _ShiftLogPageState extends State<ShiftLogPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Shift Log"),
              ],
            )));
  }
}
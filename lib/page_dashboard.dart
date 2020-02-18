import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  String title = 'Dashboard';

  DashboardPage({Key key, title}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Dashboard"),
          ],
        )));
  }
}

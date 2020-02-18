import 'package:flutter/material.dart';

class TipOutCalculatorPage extends StatefulWidget {
  String title = 'Tip Out Calculator';

  TipOutCalculatorPage({Key key, title}) : super(key: key);

  @override
  _TipOutCalculatorPageState createState() => _TipOutCalculatorPageState();
}

class _TipOutCalculatorPageState extends State<TipOutCalculatorPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      
        body: new Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Tip Out Calculator"),
          ],
        )));
  }
}

import 'package:flutter/material.dart';

class CreateShiftRecordPage extends StatefulWidget {
  @override
  _CreateShiftRecordPageState createState() => _CreateShiftRecordPageState();
}

class _CreateShiftRecordPageState extends State<CreateShiftRecordPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('<date>'),
              Container(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  child: Icon(Icons.close),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

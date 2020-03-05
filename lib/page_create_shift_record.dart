import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateShiftRecordPage extends StatefulWidget {
  CreateShiftRecordPage({Key key, title}) : super(key: key);

  @override
  _CreateShiftRecordPageState createState() => _CreateShiftRecordPageState();
}

class _CreateShiftRecordPageState extends State<CreateShiftRecordPage> {
  static DateTime selectedDate = new DateTime.now();

  var _firebaseRef = FirebaseDatabase().reference().child('temp');
  final _dateTextController = new TextEditingController(text: selectedDate.toIso8601String());
  final _takeHomeTipsTextController = new TextEditingController();
  final _claimedTipsTextController = new TextEditingController();


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030));
    if (picked != null && picked != selectedDate)
    setState(() {
      selectedDate = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Date: "),
                ),
                Text(selectedDate.toIso8601String()),
//                Expanded(
//                  child: TextField(
//                    enabled: false,
//                    textAlign: TextAlign.center,
//                    controller: _dateTextController,
//                  ),
//                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 4.0,
                  ),
                  child: RawMaterialButton(
                    child: Icon(Icons.calendar_today),
                    shape: CircleBorder(),
                    onPressed: (){
                      _selectDate(context);
                    },
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0,
                  left: 8.0),
              child: Text("Tips"),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 8.0,
                left: 8.0,
              ),
              child: Divider(
                thickness: 1.5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Take Home: "),
                  Expanded(
                      child: TextField(
                        controller: _takeHomeTipsTextController,
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 4.0
                    ),
                    child: RawMaterialButton(
                      child: Icon(Icons.grid_on),
                      shape: CircleBorder(),
                      onPressed: (){

                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Claimed: "),
                  Expanded(
                      child: TextField(
                        controller: _claimedTipsTextController,
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 4.0
                    ),
                    child: RawMaterialButton(
                      child: Icon(Icons.grid_on),
                      shape: CircleBorder(),
                      onPressed: (){

                      },
                    ),
                  )
                ],
              ),
            ),
//            Padding(
//              padding: const EdgeInsets.only(
//                top: 16.0,
//                left: 8.0,
//              ),
//              child: Text("Time Card"),
//            ),
//            Padding(
//              padding: const EdgeInsets.only(
//                  right: 8.0,
//                  left: 8.0,
//                  bottom: 8.0
//              ),
//              child: Divider(
//                thickness: 1.5,
//              ),
//            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Cancel"),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Save"),
                    onPressed: (){
                      _firebaseRef.push().set({
                        "date" : _dateTextController.text,
                        "tip_amt": _takeHomeTipsTextController.text,
                      });
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateShiftRecordPage extends StatefulWidget {
  CreateShiftRecordPage({Key key, this.title, this.data}) : super(key: key);

  String title;
  var data;

  @override
  _CreateShiftRecordPageState createState() => _CreateShiftRecordPageState();
}

class _CreateShiftRecordPageState extends State<CreateShiftRecordPage> {
  final DatabaseReference _firebaseRef = FirebaseDatabase.instance.reference();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//  Future<FirebaseUser> user = await _firebaseAuth.currentUser();
  static DateTime _selectedDate = new DateTime.now();
  String path;


  final _dateTextController = new TextEditingController(text: _selectedDate.toIso8601String());
  final _takeHomeTipsTextController = new TextEditingController();
  final _claimedTipsTextController = new TextEditingController();
  final _clockInTextController = new TextEditingController();
  final _clockOutTextController = new TextEditingController();
  final _breakTimeTextController = new TextEditingController();
  final _notesTextController = new TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030));
    if (picked != null && picked != _selectedDate)
    setState(() {
      _selectedDate = picked;
    });
  }

  _saveTipRecordToFirebase(Map data){
    var timeCard = {
      "time_card" : {
        "clock_in" : _clockInTextController.text.toString(),
        "clock_out" : _clockOutTextController.text.toString(),
        "break_time" : _breakTimeTextController.text.toString()
      }
    };

    data.addAll(timeCard);
    data["shift_note"] = _notesTextController.text.toString();

    print(data);
    _firebaseRef.child("temp2/uid").set(
        data
    ).then((value) {
      final snackBar = SnackBar(
        content: Text('Record Saved!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );

      // Find the Scaffold in the widget tree and use
      // it to show a SnackBar.
      Scaffold.of(context).showSnackBar(snackBar);
    }).catchError((e) {
      final snackBar = SnackBar(
        content: Text('Error saving record.'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            // Some code to retry.
          },
        ),
      );

      // Find the Scaffold in the widget tree and use
      // it to show a SnackBar.
      Scaffold.of(context).showSnackBar(snackBar);

      print(e);
    });


  }

  @override
  Widget build(BuildContext context) {
    Map data = widget.data;

    print(data['tips']['take_home']);
    // Need to get user_id for firebase path variable.


//    path = "users/" + _firebaseRef.

    if(data['tips']['take_home'] != 0) {
      _takeHomeTipsTextController.text = data['tips']['take_home'].toString();
    }

    return Scaffold(
      body: ListView(
          children: <Widget>[Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Date: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Text(_selectedDate.toIso8601String()),
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
                child: Text("Tips",
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 8.0),
                child: Text("Time Card",
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
                    Expanded(
                        flex: 1,
                        child: Text("Clock-In: ")
                    ),
                    Expanded(
                      flex: 1,
                        child: TextField(
                          controller: _clockInTextController,
                        )
                    ),
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
                    Expanded(
                        flex: 1,
                        child: Text("Clock-Out: ")
                    ),
                    Expanded(
                        flex: 1,
                        child: TextField(
                          controller: _clockOutTextController,
                        )
                    ),
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
                    Expanded(
                        flex: 1,
                        child: Text("Break Time: ")
                    ),
                    Expanded(
                      flex: 1,
                        child: TextField(
                          controller: _breakTimeTextController,
                        )
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 8.0),
                child: Text("Notes",
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
                    Expanded(
                      flex: 1,
                        child: TextField(
                          maxLines: null,
                          controller: _notesTextController,
                        )
                    ),
                  ],
                ),
              ),
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
                        _saveTipRecordToFirebase(data);
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ]
      ),
    );
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_picker/flutter_picker.dart';

class CreateShiftRecordPage extends StatefulWidget {
  CreateShiftRecordPage({Key key, this.title, this.data}) : super(key: key);

  String title;
  var data;

  @override
  _CreateShiftRecordPageState createState() => _CreateShiftRecordPageState();
}

class _CreateShiftRecordPageState extends State<CreateShiftRecordPage> {
  final DatabaseReference _firebaseRef = FirebaseDatabase.instance.reference();
  static DateTime now = DateTime.now();
  static TimeOfDay _selectedTime;
  static DateTime _selectedDate = _getBeginningOfDay(now);
  String path;

  final _takeHomeTipsTextController = new TextEditingController();
  final _claimedTipsTextController = new TextEditingController();
  final _clockInTextController = new TextEditingController();
  final _clockOutTextController = new TextEditingController();
  final _breakTimeTextController = new TextEditingController();
  final _notesTextController = new TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2030));
    if (date != null && date != _selectedDate) print(date.toIso8601String());
    DateTime picked = date.toLocal();
    print(picked.toIso8601String());
    setState(() {
      _selectedDate = picked;
    });
  }

  Future<Null> _selectTime(BuildContext context, TextEditingController editingController) async {
    final TimeOfDay time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        );
    if (time != null && time != _selectedTime)


    setState(() {
      DateTime timeToFormat = DateTime(1969, 1, 1, time.hour, time.minute);
      editingController.text = DateFormat.jm().format(timeToFormat);
    });
  }

  _showPickerNumber(BuildContext context) {
    new Picker(
        columnPadding: EdgeInsets.all(8.0),
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 0, end: 999),
        ]),
        delimiter: [
          PickerDelimiter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 100.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Minutes',
                        textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.title
                      ),
                    ],
                  ),
                ),
              )
          )
        ],
        hideHeader: true,
        title: new Text("Break Time Taken"),
        confirmText: 'CONFIRM',
        cancelText: 'CANCEL',
        onConfirm: (Picker picker, List value) {
          num minutes = value[0]/60;
          setState(() {
            _breakTimeTextController.text = minutes.toStringAsFixed(2);
          });
        }
    ).showDialog(context);
  }

  _saveTipRecordToFirebase(Map data) {
    

    var timeCard = {
      "time_card": {
        "clock_in": _clockInTextController.text.toString() == ""
            ? "0:00 AM"
            : _clockInTextController.text.toString(),
        "clock_out": _clockOutTextController.text.toString() == ""
            ? "0:00 AM"
            : _clockOutTextController.text.toString(),
        "break_time": _breakTimeTextController.text.toString() == ""
            ? "0.0"
            : _breakTimeTextController.text.toString(),
        "total_hours": "0.0"
      }
    };

    data.addAll(timeCard);
    data["shift_note"] = _notesTextController.text.toString();
    data["tips"]["take_home"] = _takeHomeTipsTextController.text.toString();

    print(data);
    _firebaseRef
        .child("temp2/uid/restaurant/shifts/" +
            _selectedDate.millisecondsSinceEpoch.toString())
        .set(widget.data)
        .then((value) {
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
    var buttonBoxSize = 85.0;
    Map data = widget.data["shift_data"];

    print(_selectedDate.toIso8601String());
    // Need to get user_id for firebase path variable.

//    path = "users/" + _firebaseRef.

    if (data['tips']['take_home'] != '0') {
      _takeHomeTipsTextController.text = data['tips']['take_home'].toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: ListView(children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        DateFormat.yMMMMd("en_US").format(_selectedDate),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                    ),
                    child: Container(
                      child: Ink(
                        decoration: ShapeDecoration(
                            shape: CircleBorder(
                                side: BorderSide(
                                    width: 2.0, color: Colors.black12))),
                        child: IconButton(
                          icon: Icon(MdiIcons.calendarMonth),
                          tooltip: 'Open date picker',
                          onPressed: () {
                            _selectDate(context);
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child:
                    Text("Tips", style: TextStyle(fontWeight: FontWeight.bold)),
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
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextField(
                          controller: _takeHomeTipsTextController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Take Home',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextField(
                          controller: _claimedTipsTextController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Claimed',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
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
                padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          print("Clock-In TextField tapped!");
                          _selectTime(context, _clockInTextController);
                          },
                        child: IgnorePointer(
                          child: TextField(
                            controller: _clockInTextController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Clock-In Time',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          print("Clock-In TextField tapped!");
                          _selectTime(context, _clockOutTextController);
                        },
                        child: IgnorePointer(
                          child: TextField(
                            controller: _clockOutTextController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Clock-Out Time',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          _showPickerNumber(context);
                        },
                        child: IgnorePointer(
                          child: TextField(
                            controller: _breakTimeTextController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Break Time',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
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
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        maxLines: null,
                        controller: _notesTextController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: buttonBoxSize,
                        width: buttonBoxSize,
                        padding: const EdgeInsets.all(8.0),
                        child: Ink(
                          decoration: ShapeDecoration(
                              color: Colors.red[500],
                              shape: CircleBorder(
//                                  side: BorderSide(
//                                      color: Colors.red[700],
//                                      width: 3.0
//                                  )
                              )
                          ),
                          child: IconButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            icon: Icon(MdiIcons.trashCanOutline,
                              size: 30.0,
                            color: Colors.white),
                            tooltip: 'Cancel',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: buttonBoxSize,
                        width: buttonBoxSize,
                        padding: const EdgeInsets.all(8.0),
                        child: Ink(
                          decoration: ShapeDecoration(
                              color: Colors.green[500],
                              shape: CircleBorder(
//                                  side: BorderSide(
//                                      color: Colors.green[700],
//                                      width: 3.0
//                                  )
                              )
                          ),
                          child: IconButton(
                            onPressed: (){
                              _saveTipRecordToFirebase(data);
                            },
                            icon: Icon(MdiIcons.filePlusOutline,
                              size: 30.0,
                              color: Colors.white
                            ),
                            tooltip: 'Save',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  static _getBeginningOfDay(DateTime date) {
    var dayOfYear = date.day;
    var millisInADay = Duration(days: 1).inMilliseconds; // 86400000
    var millisInHalfADay = (millisInADay ~/ 2);
    var millisDayOfYear = (dayOfYear * millisInADay);
    var millisecondsSinceEpoch =
        DateTime(DateTime.now().year).millisecondsSinceEpoch;

    print('_getBeginningOfDay: ' +
        new DateTime(date.year, date.month, date.day).toIso8601String());

//    print('_getBeginningOfDay: ' + DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch + millisDayOfYear).toIso8601String()
//        + ' '
//        + (millisecondsSinceEpoch + millisDayOfYear).toString());

    return new DateTime(date.year, date.month, date.day);
  }
}

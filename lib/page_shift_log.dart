import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:tyft_f/Position.dart';
import 'package:tyft_f/components/widget_time_card_info.dart';
import 'package:tyft_f/components/widget_tip_out_info.dart';

class ShiftLogPage extends StatefulWidget {
  String title = 'Shift Log';


  ShiftLogPage({Key key, title}) : super(key: key);

  @override
  _ShiftLogPageState createState() => _ShiftLogPageState();
}

class _ShiftLogPageState extends State<ShiftLogPage> {
  CalendarController _calendarController;
  Map<DateTime, List> _events = {};
  List _selectedEvents;
  var _firebaseRef;
  Map<dynamic, dynamic> _values;

  @override
  void initState() {
    super.initState();
    final ref = FirebaseDatabase.instance.reference();
    final _selectedDay = DateTime.now();
    _calendarController = CalendarController();
    _firebaseRef = ref;
    setState(() {
      _selectedEvents = _events[_selectedDay] ?? [];
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    day = DateTime(day.year, day.month, day.day);
    print('CALLBACK: Date Selected: ' + day.toIso8601String() + ' ' + day.millisecondsSinceEpoch.toString());

//    _values.forEach((key, value){
//      print(DateTime.fromMillisecondsSinceEpoch(int.parse(key)).toIso8601String() + ' ' + key.toString());
//    });
    Map shiftRecord = _values[day.millisecondsSinceEpoch.toString()];
//    Widget tipOutListView = _buildTipOutListView(day, _getTipOutAmounts(shiftRecord));

    if(_values.containsKey(day.millisecondsSinceEpoch.toString())){
      print("shiftRecord being passed to _showShiftRecordDialog: " + shiftRecord.toString());
      _showShiftRecordDialog(day, shiftRecord);
    }

    setState(() {
      _selectedEvents = events;
    });
  }



  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
        body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: _buildTableCalendar())
              ]
          ),
    );
  }

  Widget _buildTableCalendar() {
    Map<DateTime, List> data = {};

    return FutureBuilder(
      future: _firebaseRef.child("temp2/uid/restaurant/shifts/").once(),
      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
        if(snapshot.hasData){
          data.clear();
          _values = snapshot.data.value;
          print(_values);
          _values.forEach((key, values) {
            int tipAmount = int.parse(values['shift_data']['tips']['take_home']);
//        String dateTime = value['dateTime'];
            DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(key));
            List tipList = [];
            // if a date has already been added, add tip amount to existing list
            if(data.containsKey(date)){
              tipList.add(data[date][0]);
            }

            tipList.add("\$" + tipAmount.toString());
            data[date] = tipList;
          });

          _events = data;

              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return TableCalendar(
                    rowHeight: constraints.maxHeight/7,
                    calendarController: _calendarController,
                    events: _events,
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    availableCalendarFormats: const {
                      CalendarFormat.month: '',
                    },
                    calendarStyle: CalendarStyle(
                      markersAlignment: Alignment.center,
                      outsideDaysVisible: false,
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekendStyle: TextStyle(
                          fontSize: 16.0
                      ),
                      weekdayStyle: TextStyle(
                        fontSize: 16.0
                      )
                    ),
                    headerStyle: HeaderStyle(
                      centerHeaderTitle: true,
                      titleTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0
                      ),
                      formatButtonTextStyle:
                      TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
                      formatButtonDecoration: BoxDecoration(
                        color: Colors.deepOrange[400],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    builders: CalendarBuilders(
                      dayBuilder: (context, date, events){
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                          width: 100,
                          height: 100,
                          child: Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 16.0
                            ),
                          ),
                        );
                      },
                      selectedDayBuilder: (context, date, _) {
                        return Container(
                            margin: const EdgeInsets.all(4.0),
                            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                            width: 100,
                            height: 100,
                            child: Text(
                              '${date.day}',
                              style: TextStyle(
                                  fontSize: 16.0
                              ),
                            ),
                        );
                      },
                      todayDayBuilder: (context, date, _) {
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          padding: const EdgeInsets.only(top: 5.0, left: 6.0),

                          width: 100,
                          height: 100,
                          child: Text(
                            '${date.day}',
                            style: TextStyle().copyWith(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[600]),
                          ),
                        );
                      },
                      markersBuilder: (context, date, events, holidays) {
                        final children = <Widget>[];

                        if (events.isNotEmpty) {
                          children.add(_buildEventsMarker(date, events),
                          );
                        }
                        return children;
                      },
                    ),
                    onDaySelected: _onDaySelected,
                  );
                }
                );
        }
        return CircularProgressIndicator();
      }
    );
  }

  _showShiftRecordDialog(DateTime day, shiftRecord) {
    String title = DateFormat.yMMMMd("en_US").format(day);
    print('shiftRecordDialog: \n' + shiftRecord.toString());
    String takeHomeTips = shiftRecord['shift_data']['tips']['take_home'];
    print('Take Home Tips: ' + takeHomeTips);

    Widget tipInfoWidget;
    List tipOutAmounts = _getTipOutAmounts(shiftRecord);
    if(tipOutAmounts != null){
      tipInfoWidget = TipOutInfoWidget(
        tipOutAmounts:  tipOutAmounts,
        takeHomeTipAmount: shiftRecord['shift_data']['tips']['take_home'],
      );
    } else {
      tipInfoWidget = Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Row(
          children: <Widget>[
            Text("Take Home Tips: "),
            Text("\$" + takeHomeTips,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green
              ),)
          ],
        ),
      );
    }


    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(title),
          content: Container(
            height: 250,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('Shift Info',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0
                            )),
                      ],
                    ),
                    Divider(
                      height: 2,
                      thickness: 2,
                    ),
                      tipInfoWidget,
                      TimeCardInfoWidget(
                        timeCardData: shiftRecord['shift_data']['time_card'],
                      ),
                    Row(
                      children: <Widget>[
                        Text('Shift Stats',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0
                            )),
                      ],
                    ),
                    Divider(
                      height: 2,
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 7,
                                child: Text('Total Earned:')),
                            Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Text('\$---',
                                  textAlign: TextAlign.end,),
                                )
                            ),
                          ],
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 7,
                              child: Text('Hourly Rate:')),
                          Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Text('\$---/hr',
                                textAlign: TextAlign.end,),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("EDIT"),
              onPressed: () {
                // Edit functions
                
              },
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _getTipOutAmounts(Map shiftRecord){
    print("_getTipOutAmounts: shiftRecord passed: " + shiftRecord.toString());
    if(shiftRecord['shift_data']['tips'].containsKey('tip_out_amounts')){
      print("_getTipOutAmounts: returning tipOutAmount: " + shiftRecord['shift_data']['tips']['tip_out_amounts'].toString());
      return shiftRecord['shift_data']['tips']['tip_out_amounts'];
    }
    return null;
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    Color _selectedColor = Colors.orange[300];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? _selectedColor : Colors.green[400]
      ),
      width: 32.0,
      height: 16.0,
      child: Center(
        child: Text(events[0].toString(),
            style: TextStyle().copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 12.0,
            ),
        ),
      ),
    );
  }

//  Widget _buildEventList() {
//    return ListView(
//      children: _selectedEvents
//          .map((event) => Container(
////        decoration: BoxDecoration(
////          border: Border.all(width: 0.8),
////          borderRadius: BorderRadius.circular(12.0),
////        ),
//        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//        child: Card(
//          child: ExpansionTile(
//              title: Text(event.toString()),
//              children: <Widget>[
//                Text("More Text"),
//                Text("More Text"),
//                Text("More Text")
//              ],
//            ),
//        )
//      ))
//          .toList(),
//    );
//  }
}
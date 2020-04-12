import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_database/firebase_database.dart';

class ShiftLogPage extends StatefulWidget {
  String title = 'Shift Log';
  final DatabaseReference _firebaseRef = FirebaseDatabase.instance.reference();


  ShiftLogPage({Key key, title}) : super(key: key);

  @override
  _ShiftLogPageState createState() => _ShiftLogPageState(readData());

  readData() {
    Map<DateTime, List> data = {};

    _firebaseRef.child("temp2").once().then((dataSnapshot){
      dataSnapshot.value.forEach((key, value){
        print("Date: " + value['dateTime'] + " Tip amount: " + value['tips']['take_home'] + "\n");
        int tipAmount = int.parse(value['tips']['take_home']);
        String dateTime = value['dateTime'];
        DateTime date = DateTime.parse(dateTime);
        List tipList = [];
        // if a date has already been added, add tip amount to existing list
        if(data.containsKey(date)){
          tipList.add(data[date][0]);
        }

        tipList.add("\$" + tipAmount.toString());
        data[date] = tipList;

      });
    }).catchError((e) {
      print("Failed to load tip records");
      print(e);
    });

    return data;
  }
}

class _ShiftLogPageState extends State<ShiftLogPage> {
  CalendarController _calendarController;
  Map<DateTime, List> _events = {};
  List _selectedEvents;

  _ShiftLogPageState(Map<DateTime, List> data) {
    print("Shift Log Page constructor called...");
    _events = data;
  }

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    _calendarController = CalendarController();

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
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  @override
  Widget build(BuildContext context) {
    TableCalendar tableCalendar = _buildTableCalendar();

    return new Scaffold(
        body: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[tableCalendar,
              Expanded(child: _buildEventList()),
            RaisedButton(
              child: Text("Read Data"),
              onPressed: (){
              },
            ),]
        ),
    );
  }

  Widget _buildTableCalendar() {

    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
      },
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.8),
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          title: Text(event.toString()),
          onTap: () => print('$event tapped!'),
        ),
      ))
          .toList(),
    );
  }


}

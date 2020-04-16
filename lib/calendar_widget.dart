import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  CalendarWidget({Key key, this.data}) : super(key: key);

  Map<DateTime, List> data;

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarController _calendarController;
  Map<DateTime, List> _events;
  List _selectedEvents;
  GlobalKey _globalKey = GlobalKey();


  @override
  void initState() {
    final _selectedDay = DateTime.now();
    _calendarController = CalendarController();
    setState(() {
      _selectedEvents = _events[_selectedDay] ?? [];
      _events = widget.data;
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return TableCalendar(
      key: _globalKey,
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

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }
}

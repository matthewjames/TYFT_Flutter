import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class TimeCardInfoWidget extends StatefulWidget {
  TimeCardInfoWidget({Key key, this.timeCardData}) : super(key: key);

  final Map<dynamic, dynamic> timeCardData;

  @override
  _TimeCardInfoWidgetState createState() => _TimeCardInfoWidgetState();
}

class _TimeCardInfoWidgetState extends State<TimeCardInfoWidget> {


  @override
  Widget build(BuildContext context) {

    return ExpandablePanel(
      header: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Text("Time Card"),
      ),
      expanded: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 4.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
              Expanded(
                flex: 1,
                  child: Text("Clock In: ")
              ),
                Expanded(
                  flex: 1,
                  child: Text(widget.timeCardData['clock_in'],
                  textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Text("Clock Out: ")
                ),
                Expanded(
                  flex: 1,
                  child: Text(widget.timeCardData['clock_out'],
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Text("Break Time: ")
                ),
                Expanded(
                  flex: 1,
                  child: Text(widget.timeCardData['break_time'],
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Text("Total Hours: ")
                ),
                Expanded(
                  flex: 1,
                  child: Text(widget.timeCardData['total_hours'],
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
          ]
        ),
      ),
    );
  }
}

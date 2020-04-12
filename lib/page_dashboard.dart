import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key, this.title}) : super(key: key);

  String title;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static DatabaseReference _firebaseRef = FirebaseDatabase.instance.reference();
  var chart = FutureBuilder(
      future: _firebaseRef.child("temp2/uid/restaurant/shifts/").once(),
      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
        List<Shift> data = new List<Shift>();
        if (snapshot.hasData) {
          data.clear();
          Map<dynamic, dynamic> values = snapshot.data.value;
          values.forEach((key, values) {
            int tipAmount = int.parse(values['shift_data']['tips']['take_home']);
            print("Date: " + key + " Tip Amount: " + tipAmount.toString());
            DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(key));

            data.add(new Shift(date, tipAmount));
          });
          data.sort((a,b) => a.date.compareTo(b.date));
          
          print(data);

          return new SimpleTimeSeriesChart.withShiftData(data);
        }
        return CircularProgressIndicator();
      });

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        body: ListView(
            children: <Widget>[
              Container(child: 
                SizedBox(
                    height: 200,
                    width: 200,
                    child: chart
                )
              )
            ]
        )
    );
  }
}

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;

  SimpleTimeSeriesChart(this.seriesList);

  factory SimpleTimeSeriesChart.withShiftData(List<Shift> shifts) {
    List<TimeSeriesSimple> mapped = shifts.map((item) {
      return TimeSeriesSimple(item.date, item.tip_amt);
    }).toList();

    List<charts.Series<TimeSeriesSimple, DateTime>> list = [
      charts.Series<TimeSeriesSimple, DateTime>(
        id: 'Tips',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesSimple shift, _) => shift.date,
        measureFn: (TimeSeriesSimple shift, _) => shift.tips,
        data: mapped,
      )
    ];

    return SimpleTimeSeriesChart(list);
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animationDuration: Duration(milliseconds: 500),
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }
}

/// Sample time series data type.
class TimeSeriesSimple {
  final DateTime date;
  final int tips;

  TimeSeriesSimple(this.date, this.tips);
}

class Shift {
  final DateTime date;
  final int tip_amt;

  Shift(this.date, this.tip_amt);
}

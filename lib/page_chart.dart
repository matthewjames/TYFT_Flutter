import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class ChartPage extends StatefulWidget {
  ChartPage({Key key, this.title}) : super(key: key);

  static const String routeName = "/ChartPage";

  final String title;


  @override
  _ChartPageState createState() => new _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  static DatabaseReference _firebaseRef = FirebaseDatabase.instance.reference();
  static List<Shift> _tipData;
  static var _average;

  @override
  Widget build(BuildContext context) {
    Widget chart = _buildChart();

    return Container(
      padding: EdgeInsets.only(right: 16.0, left: 16.0, bottom: 24.0, top: 16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center ,
            children: <Widget>[
              Expanded(child: Card(
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Year to Date')
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                                child: chart
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("YTD Average: \$" + _average.toString())
                              ],
                            ),
                          )
                        ],
                      )))),
            ]
        )
    );
  }

  Widget _buildChart(){
    return FutureBuilder(
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
            _tipData = data;
            _average = _getAverageTipsYTD(_tipData);

            return Flex(
              children: <Widget>[
                Expanded(child: new SimpleTimeSeriesChart.withShiftData(data))
              ], direction: Axis.horizontal,
            );
          }
          return Flex(
            children: <Widget>[
              Expanded(child: Center(child: new CircularProgressIndicator()))
            ], direction: Axis.horizontal,
          );
        });
  }

  _getAverageTipsYTD(List<Shift> data){
    var sum = 0;

    for(var i = 0; i < data.length; i++){
      sum += data[i].tip_amt;
    }

    return sum~/data.length;
  }

}

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;

  final simpleCurrencyFormatter =
  new charts.BasicNumericTickFormatterSpec.fromNumberFormat(
      new NumberFormat.compactSimpleCurrency(
        decimalDigits: 0
      )
  );
  final customTickFormatter =
     charts.BasicNumericTickFormatterSpec((num value) => 'MyValue: $value');

  SimpleTimeSeriesChart(this.seriesList);

  factory SimpleTimeSeriesChart.withShiftData(List<Shift> shifts) {
    List<TimeSeriesSimple> mapped = shifts.map((item) {
      return TimeSeriesSimple(item.date, item.tip_amt);
    }).toList();

    List<charts.Series<TimeSeriesSimple, DateTime>> list = [
      charts.Series<TimeSeriesSimple, DateTime>(
        id: 'Tips',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
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
      animationDuration: Duration(milliseconds: 300),
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      primaryMeasureAxis: new charts.NumericAxisSpec(
          tickFormatterSpec: simpleCurrencyFormatter),
        domainAxis: new charts.DateTimeAxisSpec(
            tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                day: new charts.TimeFormatterSpec(
                    format: 'd', transitionFormat: 'MMMM')))
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
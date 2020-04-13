import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';
import 'package:tyft_f/page_chart.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key, this.title}) : super(key: key);

  String title;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static DatabaseReference _firebaseRef = FirebaseDatabase.instance.reference();
  static Widget chart = FutureBuilder(
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

  final List<Widget> _charts = [
    new ChartPage(title: "Chart 1", chart: chart),
    new ChartPage(title: "Chart 2", chart: chart),
    new ChartPage(title: "Chart 3", chart: chart)
  ];

  final _pageController = PageController(
    initialPage: 0
  );
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _boxHeight = 700.0;

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          _buildPageView(),
                          _buildCircleIndicator()
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  _buildPageView() {
    return Container(
      height: _boxHeight,
      child: PageView(
          controller: _pageController,
          children: _charts,
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
          }),
    );
  }

  _buildCircleIndicator() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          itemCount: _charts.length,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
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

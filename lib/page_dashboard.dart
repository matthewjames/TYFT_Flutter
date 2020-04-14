import 'package:flutter/material.dart';
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



  final List<Widget> _charts = [
    new ChartPage(title: "Chart 1"),
    new ChartPage(title: "Chart 2"),
    new ChartPage(title: "Chart 3")
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





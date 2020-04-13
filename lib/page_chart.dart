import 'package:flutter/material.dart';

class ChartPage extends StatefulWidget {
  ChartPage({Key key, this.title, this.chart}) : super(key: key);

  static const String routeName = "/ChartPage";

  final String title;
  Widget chart;

  @override
  _ChartPageState createState() => new _ChartPageState();
}

/// // 1. After the page has been created, register it with the app routes
/// routes: <String, WidgetBuilder>{
///   ChartPage.routeName: (BuildContext context) => new ChartPage(title: "ChartPage"),
/// },
///
/// // 2. Then this could be used to navigate to the page.
/// Navigator.pushNamed(context, ChartPage.routeName);
///

class _ChartPageState extends State<ChartPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
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
                                Text(widget.title)
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Container(
                                child: widget.chart
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("More Information")
                              ],
                            ),
                          )
                        ],
                      )))),
            ]
        )
    );
  }
}
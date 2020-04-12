import 'package:flutter/material.dart';
import 'package:tyft_f/page_create_shift_record.dart';
import 'package:tyft_f/page_dashboard.dart';
import 'package:tyft_f/page_shift_log.dart';
import 'package:tyft_f/page_tip_out_calculator.dart';
import 'package:custom_navigator/custom_scaffold.dart';
import 'package:custom_navigator/custom_navigation.dart';
import 'package:custom_navigator/custom_navigator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'TYFT'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  List<Widget> _pages = [DashboardPage(title: "Dashboard"), TipOutCalculatorPage(title: "Tip Out Calculator"), ShiftLogPage(title: "Shift Log")];
  List<String> _titles = ["Dashboard", "Tip Out Calculator", "Shift Log"];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      widget.title = _titles[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffold: Scaffold(
        appBar: AppBar(
        title: Text(widget.title),
      ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: _items,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
      children: _pages,
    );
  }

  final _items = [
    BottomNavigationBarItem(
    icon: Icon(Icons.home),
    title: Text('Home'),
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.grid_on),
    title: Text('Calculator'),
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.calendar_today),
    title: Text('Shift Log'),
    ),
  ];
}

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tyft_f/page_create_shift_record.dart';
import 'package:tyft_f/page_dashboard.dart';
import 'package:tyft_f/page_profile.dart';
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
        primarySwatch: Colors.green,
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

  List<Widget> _pages = [
    DashboardPage(title: "Dashboard"),
    TipOutCalculatorPage(title: "Tip Out Calculator"),
    ShiftLogPage(title: "Shift Log"),
    ProfilePage(title: "Profile")
  ];
  static List<String> _titles = ["Dashboard", "Tip Out Calculator", "Shift Log", "Profile"];
  static String currentTitle = _titles[0];

  void _onItemTapped(int index) {
    setState(() {
      currentTitle = _titles[index];
      _selectedIndex = index;
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
          selectedItemColor: Colors.orange[300],
          unselectedItemColor: Colors.black26,
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
    icon: Icon(MdiIcons.calculatorVariant),
    title: Text('Calculator'),
    ),
    BottomNavigationBarItem(
    icon: Icon(MdiIcons.calendarText),
    title: Text('Shift Log'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle),
      title: Text('Profile'),
    ),
  ];
}

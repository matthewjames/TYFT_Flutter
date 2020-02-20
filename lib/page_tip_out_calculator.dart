import 'package:flutter/material.dart';
import 'package:tyft_f/Position.dart';

class TipOutCalculatorPage extends StatefulWidget {
  String title = 'Tip Out Calculator';

  TipOutCalculatorPage({Key key, title}) : super(key: key);

  @override
  _TipOutCalculatorPageState createState() => _TipOutCalculatorPageState();
}

class _TipOutCalculatorPageState extends State<TipOutCalculatorPage> {
  var _positions = [
    new Position('Busser', null, 20.0),
    new Position('Bar', 'Micah', 7.5),
    new Position('Runner', null, 5.0)
  ];

  var _totalTipOut = 0;

  String _getName(position){
    return _positions[position].name == null ? '' : _positions[position].name;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
//        crossAxisAlignment: CrossAxisAlignment.center,
//        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(flex: 1, child: Text('Gross Tip Amount:')),
              Expanded(
                flex: 1,
                child: TextField(),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemBuilder: (context, position) {
                  return Container(
                    child: Card(
                      child: Container(
                        margin: EdgeInsets.all(16),
                        child: Row(
                          children: <Widget>[
                            Expanded(child: Text(_positions[position].tipPercentage.toString() + '%')),
                            Expanded(child: Text(_positions[position].title)),
                            Expanded(child: Text(_getName(position))),
                            Expanded(child: Text(_positions[position].tipOutAmount.toString(),
                                    textAlign: TextAlign.end),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: _positions.length,
            ),
          ),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: Text('Total Tip Out: -\$$_totalTipOut',
                  textAlign: TextAlign.end,)),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(child: Text('Net Gratuity:  \$$_totalTipOut',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          onPressed: (){},
                          child: Text('Clear')),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          onPressed: (){},
                          child: Text('Calculate')),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          onPressed: (){},
                          child: Text('Log Tips >')),
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

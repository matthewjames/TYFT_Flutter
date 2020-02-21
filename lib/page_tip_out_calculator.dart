import 'package:flutter/material.dart';
import 'package:tyft_f/Position.dart';
import 'package:tyft_f/page_shift_log.dart';

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

  var _totalTipOut = 0, _netGratuity = 0;
  final grossTipsController = new TextEditingController();

  String _getName(position){
    return _positions[position].name == null ? '' : _positions[position].name;
  }

  void _calculate(grossTipAmount){
    // reset variables
    _totalTipOut = 0;
    _netGratuity = 0;

    for (int i = 0; i < _positions.length; i++){
      // multiply gross tip amount to tip percentage of each position
      var tipAmount = (grossTipAmount * (_positions[i].tipPercentage * 0.01)).round();

      // track total tip out amount
      _totalTipOut += tipAmount;

      // set tip amount for position
      _positions[i].setTipOutAmount(tipAmount);
    }

    _netGratuity = grossTipAmount - _totalTipOut;

    setState(() {

    });
  }

  void _showPositionEditorDialog(title) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(title),
          content: Container(
            height: 100,
            child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            autofocus: false,
                            decoration: InputDecoration(
                              labelText: 'Tip Out %',
                            ),
                            onChanged: (value){

                            },
                          ),
                        ),
                        Expanded(
                          child: DropdownButton(
                            items: null,
                            onChanged: null,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(flex: 1, child: Text('Gross Tip Amount:')),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: grossTipsController,
                  autofocus: false,),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
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
                          Expanded(child: Text('\$' + _positions[position].tipOutAmount.toString(),
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
          Center(
            child: FlatButton(
              onPressed: (){
                _showPositionEditorDialog('Add a position');
              },
              child: Text('+ Quick Add'),
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 8.0),
                child:
                  Text('Total Tip Out: -\$$_totalTipOut',
                  textAlign: TextAlign.end,
                  ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 8.0),
                child:
                  Text('Net Gratuity:  \$$_netGratuity',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          onPressed: (){
                            _calculate(0);
                            grossTipsController.text = '';
                          },
                          child: Text('Clear')),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          onPressed: (){
                            _calculate(int.parse(grossTipsController.text));
                          },
                          child: Text('Calculate')),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          onPressed: (){
                            setState(() {
                              ShiftLogPage();
                            });
                          },
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

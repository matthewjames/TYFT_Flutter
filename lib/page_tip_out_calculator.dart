import 'package:flutter/material.dart';
import 'package:tyft_f/Position.dart';
import 'package:tyft_f/page_create_shift_record.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class TipOutCalculatorPage extends StatefulWidget {
  TipOutCalculatorPage({Key key, this.title}) : super(key: key);

  String title;

  @override
  _TipOutCalculatorPageState createState() => _TipOutCalculatorPageState();
}

class _TipOutCalculatorPageState extends State<TipOutCalculatorPage> {
  var _positions = [
    new Position("Busser", "", 20.0),
    new Position("Bar", "", 7.5),
    new Position("Runner", "", 5.0)
  ];

  var _totalTipOut = 0, _netGratuity = 0;
  var _shiftData;
  final grossTipsController = new TextEditingController();

  var tipOutAmounts = {};

  String _getName(position){
    return _positions[position].name == null ? '' : _positions[position].name;
  }

  void _calculate(grossTipAmount){
    // reset variables
    _totalTipOut = 0;
    _netGratuity = 0;

    for (int i = 0; i < _positions.length; i++){
      Position currentPosition = _positions[i];

      // multiply gross tip amount to tip percentage of each position
      var tipAmount = (grossTipAmount * (currentPosition.tipPercentage * 0.01)).round();

      // track total tip out amount
      _totalTipOut += tipAmount;

      // set tip amount for position
      currentPosition.setTipOutAmount(tipAmount);

      // add to output shiftData object
      tipOutAmounts.addAll({
            i.toString() : {
              "position" : {
                "title" : currentPosition.title,
                "name" : currentPosition.name,
                "tip_out_percentage" : currentPosition.tipPercentage.toString()
              },
              "tip_out_amount" : tipAmount.toString()
              }
            });
      }


    _netGratuity = grossTipAmount - _totalTipOut;

    print(tipOutAmounts);
    setState(() {

    });
  }

  _showPositionEditorDialog(title) {
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
    var buttonBoxSize = 85.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Gross Tip Payout',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                    )),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 75.0, right: 75.0, top: 8.0, bottom: 16.0),
                      child: TextField(
                        controller: grossTipsController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold
                        ),
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                  itemBuilder: (context, position) {
                    return Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Card(
                        child: InkWell(
                          splashColor: Colors.black12.withAlpha(30),
                          onTap: (){
                            print("Position " + position.toString() + " clicked!");
                          },
                          child: Container(
                            margin: EdgeInsets.all(16),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(_positions[position].tipPercentage.toString() + '%',
                                    style: TextStyle(
                                      fontSize: 18.0
                                    ),)
                                ),
                                Expanded(child: Text(_positions[position].title,
                                  style: TextStyle(
                                      fontSize: 18.0
                                  ),)),
                                Expanded(child: Text(_getName(position),
                                  style: TextStyle(
                                      fontSize: 18.0
                                  ),)),
                                Expanded(child: Text('\$' + _positions[position].tipOutAmount.toString(),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 18.0
                                        ),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: _positions.length,
              ),
              Center(
                child: OutlineButton(
                  onPressed: (){
                    _showPositionEditorDialog('Add a position');
                  },
                  child: Text('+ Quick Add'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 32.0, left: 32.0, top: 8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.all(4.0),
                        child:
                          Text('Total Tip Out: -\$$_totalTipOut',
                          textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 18.0
                              )
                          ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.all(4.0),
                        child:
                          Text('Net Gratuity:  \$$_netGratuity',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                fontSize: 18.0
                              )
                          ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: buttonBoxSize,
                                width: buttonBoxSize,
                                padding: const EdgeInsets.all(8.0),
                                child: Ink(
                                  decoration: ShapeDecoration(
                                    color: Colors.yellow[100],
                                    shape: CircleBorder(
                                      side: BorderSide(
                                        color: Colors.yellow[700],
                                        width: 3.0
                                      )
                                    )
                                  ),
                                  child: IconButton(
                                      onPressed: (){
                                        _calculate(0);
                                        grossTipsController.text = '';
                                      },
                                      icon: Icon(Icons.refresh,
                                      size: 30.0,),
                                    tooltip: 'Clear all entries and reset calculator',
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: buttonBoxSize,
                                width: buttonBoxSize,
                                padding: const EdgeInsets.all(8.0),
                                child: Ink(
                                  decoration: ShapeDecoration(
                                    color: Colors.orange[100],
                                      shape: CircleBorder(
                                          side: BorderSide(
                                              color: Colors.orange[300],
                                              width: 3.0
                                          )
                                      )
                                  ),
                                  child: IconButton(
                                    onPressed: (){
                                      _calculate(int.parse(grossTipsController.text));
                                    },
                                    icon: Icon(
                                        MdiIcons.calculator,
                                    size: 30.0),
                                    tooltip: 'Calculate tip outs',
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: buttonBoxSize,
                                width: buttonBoxSize,
                                padding: const EdgeInsets.all(8.0),
                                child: Ink(
                                  decoration: ShapeDecoration(
                                      color: Colors.green[100],
                                      shape: CircleBorder(
                                          side: BorderSide(
                                              color: Colors.green[400],
                                              width: 3.0
                                          )
                                      )
                                  ),
                                  child: IconButton(
                                    onPressed: (){
                                      _shiftData = {
                                        "dateTime" : DateTime.now().toIso8601String(),
                                        "shift_data" : {
                                          "tips" : {
                                            "tip_out_amounts" : tipOutAmounts,
                                            "take_home" : _netGratuity.toString(),
                                            "claimed" : "0"
                                          },
                                          "shift_note" : ""
                                        }
                                      };

                                      print('TipOutCalcuPage: data sent to CreateShiftRecordPage: \n' + _shiftData.toString());
                                      _openCreateShiftRecordPage(context);
                                    },
                                    icon: Icon(
                                        MdiIcons.fileDocumentEditOutline,
                                    size: 30.0,),
                                    tooltip: 'Log tip information',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  _openCreateShiftRecordPage(BuildContext context) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => CreateShiftRecordPage(title: "Create Shift Record", data: _shiftData,)));
}

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
  static var _positions = [
    new Position("Busser", "", 20.0),
    new Position("Bar", "", 7.5),
    new Position("Runner", "", 5.0)
  ];
  var _selectedPosition = _positions[0];

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
            height: 225,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[Container(
                            width: 100,
                            height: 80,
                            child: TextField(
                                autofocus: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Tip Out %',
                                  labelStyle: TextStyle(
                                    fontSize: 16.0
                                  )
                                ),
                                style: TextStyle(
                                  fontSize: 30.0
                                ),
                                textAlign: TextAlign.center,
                                onChanged: (value){

                                },
                              ),
                            ),
                          ]
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      elevation: 0,
                                      items: _positions.map<DropdownMenuItem<Position>>((Position value) {
                                      return DropdownMenuItem<Position>(
                                          value: value,
                                          child: Text(value.title),
                                        );
                                      }).toList(),
                                      onChanged: (position){
                                        _selectedPosition = position;
                                      },
                                      value: _selectedPosition,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),


                  TextField(
                    autofocus: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name (Optional)',
                    ),
                    onChanged: (value){

                    },
                  ),
                ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("CANCEL"),
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
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
                    child: Text('Total Tips',
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
              _buildPositionListView(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: OutlineButton(
                    onPressed: (){
                      _showPositionEditorDialog('Add a position');
                    },
                    child: Text('+ Quick Add'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0, top: 8.0),
                child: Row(children: <Widget>[
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text('Total Tip Out:',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 18.0
                        )
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 4.0),
                        child: Text('-\$$_totalTipOut',
                        style: TextStyle(
                          color: Colors.red[500],
                          fontSize: 18.0
                        )),
                      )
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0, top: 8.0),
                child: Row(children: <Widget>[
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text('Take Home:',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 18.0,
                            fontWeight: FontWeight.bold
                          )
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                        child: Text('\$$_netGratuity',
                            style: TextStyle(
                                color: Colors.green[500],
                                fontSize: 18.0,
                              fontWeight: FontWeight.bold
                            )),
                      )
                  )
                ],),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: buttonBoxSize,
                        width: buttonBoxSize,
                        padding: const EdgeInsets.all(8.0),
                        child: Ink(
                          decoration: ShapeDecoration(
                              color: Colors.yellow[700],
                              shape: CircleBorder(
//                                      side: BorderSide(
//                                        color: Colors.yellow[700],
//                                          width: 3.0
//                                      )
                              )
                          ),
                          child: IconButton(
                            onPressed: (){
                              _calculate(0);
                              grossTipsController.text = '';
                            },
                            icon: Icon(Icons.refresh,
                              size: 30.0,
                              color: Colors.white,),
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
                              color: Colors.orange[700],
                              shape: CircleBorder(
//                                          side: BorderSide(
//                                              color: Colors.orange[300],
//                                              width: 3.0
//                                          )
                              )
                          ),
                          child: IconButton(
                            onPressed: (){
                              _calculate(int.parse(grossTipsController.text));
                            },
                            icon: Icon(
                                MdiIcons.calculator,
                                size: 30.0,
                                color: Colors.white),
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
                              color: Colors.green[500],
                              shape: CircleBorder(
//                                          side: BorderSide(
//                                              color: Colors.green[400],
//                                              width: 3.0
//                                          )
                              )
                          ),
                          child: IconButton(
                            onPressed: (){
                              _shiftData = {
                                "date_time_created" : DateTime.now().toIso8601String(),
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
                                size: 30.0,
                                color: Colors.white),
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
      ),
    );
  }

  _buildPositionListView(){
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final position = _positions[index];
        return Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Dismissible(
            key: ObjectKey(position),
            onDismissed: (direction){
              setState(() {
                _positions.removeAt(index);
              });
              Scaffold
                  .of(context)
                  .showSnackBar(SnackBar(
                  content: Text(position.title + " removed."),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: (){
                          setState(() {
                            _positions.insert(index, position);
                          });
                        },
                      ),
                ),
              );
            },
            child: Card(
              child: InkWell(
                splashColor: Colors.black12.withAlpha(30),
                onTap: (){
                  print("Position " + index.toString() + " clicked!");
                  _selectedPosition = _positions[index];
                  _showPositionEditorDialog('Edit Position');
                },
                child: Container(
                  margin: EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(_positions[index].tipPercentage.toString() + '%',
                            style: TextStyle(
                                fontSize: 18.0
                            ),)
                      ),
                      Expanded(child: Text(_positions[index].title,
                        style: TextStyle(
                            fontSize: 18.0
                        ),)),
                      Expanded(child: Text(_getName(index),
                        style: TextStyle(
                            fontSize: 18.0
                        ),)),
                      Expanded(child: Text('\$' + _positions[index].tipOutAmount.toString(),
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
          ),
        );
      },
      itemCount: _positions.length,
    );
  }

  _openCreateShiftRecordPage(BuildContext context) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => CreateShiftRecordPage(title: "Create Shift Record", data: _shiftData,)));
}

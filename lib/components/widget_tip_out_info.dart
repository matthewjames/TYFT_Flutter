import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class TipOutInfoWidget extends StatefulWidget {
  TipOutInfoWidget({Key key, this.tipOutAmounts, this.takeHomeTipAmount}) : super(key: key);

  final List<dynamic> tipOutAmounts;
  final String takeHomeTipAmount;

  @override
  _TipOutInfoWidgetState createState() => _TipOutInfoWidgetState();
}

class _TipOutInfoWidgetState extends State<TipOutInfoWidget> {


  @override
  Widget build(BuildContext context) {
    print("tipOutAmounts: " + widget.tipOutAmounts.toString());

    return ExpandablePanel(
      header: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Row(
          children: <Widget>[
            Text("Take Home Tips: "),
            Text("\$" + widget.takeHomeTipAmount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green
            ),)
          ],
        ),
      ),
      expanded: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Column(
          children: _buildPositionPanels(),
        ),
      ),
    );
  }

  _buildPositionPanels(){
    print("_buildPositionPanels() triggered");
    var positionWidgets = <Widget>[];
    var length = widget.tipOutAmounts.length;
    print("widget.tipOutAmounts.length = " + length.toString());

    for(int i = 0; i < length; i++){
      String name = widget.tipOutAmounts[i]['position']['name'];
      Widget nameWidget;

      if(name == ''){
        nameWidget = Text('');
      } else {
        nameWidget = Text('(' + name + ')');
      }

      positionWidgets.add(Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Text(widget.tipOutAmounts[i]['position']['title']),
          ),
          Expanded(
            flex: 4,
            child: nameWidget,
          ),
          Expanded(
            flex: 2,
            child: Text('\$' + widget.tipOutAmounts[i]['tip_out_amount'],
            textAlign: TextAlign.end,),
          ),
        ],
        )
      );
    }

    return positionWidgets;
  }
}

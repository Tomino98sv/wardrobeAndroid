import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterChipDisplay extends StatefulWidget {
  @override
  _FilterChipDisplayState createState() => _FilterChipDisplayState();
}

var counter = 0;
bool selectedWidget = false;

class _FilterChipDisplayState extends State<FilterChipDisplay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Choose category",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 3.0, left: 8.0),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              child: Wrap(
                spacing: 7.0,
                runSpacing: 3.0,
                children: <Widget>[
                  FilterChipWidget(
                    chipName: 'Size',
                    onPressed: () {
                      setState(() {
                        selectedWidget = !selectedWidget;
                      });
                    },
                  ),
                  FilterChipWidget(
                    chipName: 'Length',
                  ),
                  FilterChipWidget(
                    chipName: 'Color',
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 1,
          color: Colors.grey,
        ),
        Container(
            child:
                selectedWidget == true ? _buildExpandedWidget() : Container())
      ],
    );
  }
}

class FilterChipWidget extends StatefulWidget {
  final String chipName;
  final Function onPressed;

  FilterChipWidget({Key key, this.chipName, this.onPressed})
      : super(key: key);

  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(
          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400),
      selected: _isSelected,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: Colors.grey)),
      backgroundColor: Colors.pink[100],
      onSelected: (isSelected) {
        widget.onPressed();
        setState(() {
          _isSelected = isSelected;
          debugPrint("${isSelected}");
          if (isSelected) {
            counter++;
            debugPrint("$counter");
            selectedWidget = true;
//           debugPrint("$selectedWidget");
          } else {
            debugPrint("neda to proste");
          }
        });
      },
      selectedColor: Colors.pinkAccent,
    );
  }
}
List<String> sizes = ['34', '36', '38', '40', '42', '44', '46', '48'];
int _currentItemSelected = 0;

Widget _buildExpandedWidget() {
  debugPrint("malo by vykreslit dropdown menu");
  return CupertinoAlertDialog(
   actions:<Widget>[
     CupertinoDialogAction(
       isDefaultAction: true,
       child: SizedBox(
         width: 100,
         height: 100,
         child: CupertinoPicker(
             itemExtent: 30,
             backgroundColor: CupertinoColors.white,
             onSelectedItemChanged: (index){
               _currentItemSelected = index;
               print(_currentItemSelected);
             },
             children: List<Widget>.generate(sizes.length, (index) {
               return Center(
                 child: Text(sizes[index]),
               );
             },
             )
         ),
       ),
     )
   ] ,
  );
//  return DropdownButton<String>(
//    items: _sizes.map((String dropDownStringItem) {
//      return DropdownMenuItem<String>(
//        value: dropDownStringItem,
//        child: Text(dropDownStringItem),
//      );
//    }).toList(),
//    onChanged: (String newValueSelected) {
//      _currentItemSelected = newValueSelected;
//      size = newValueSelected;
//    },
//    value: _currentItemSelected,
//  );
}

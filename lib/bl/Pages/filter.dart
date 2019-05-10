import 'package:flutter/material.dart';

class FilterChipDisplay extends StatefulWidget {
  @override
   _FilterChipDisplayState createState() => _FilterChipDisplayState();
  }



class _FilterChipDisplayState extends State<FilterChipDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter search"),
      ),
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Choose category",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
              ),
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
                  FilterChipWidget(chipName: 'Size', chipFunction: buildExpandedWidget()),
                  FilterChipWidget(chipName: 'Length',),
                  FilterChipWidget(chipName: 'Color',),
                ],
              ),
            ),
          ),
           ),
          Container(
            height: 1,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}



class FilterChipWidget extends StatefulWidget{
  final String chipName;
  Function chipFunction;

  FilterChipWidget({Key key, this.chipName, this.chipFunction}) : super(key: key);

  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget>{
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(
        color: Colors.black,
        fontSize: 16.0,
        fontWeight: FontWeight.w400
      ),
      selected: _isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side: BorderSide(
          color: Colors.grey
        )
      ),
      backgroundColor: Colors.pink[100],
      onSelected: (isSelected){
        setState(() {
         if(_isSelected = isSelected){
           widget.chipFunction();
         }
        });
      },
      selectedColor: Colors.pinkAccent,

    );
  }
}

buildExpandedWidget(){
  String size;
  var _sizes = ['34', '36', '38', '40', '42', '44', '46', '48'];
  var _currentItemSelected = '38';
  Expanded(
    child: DropdownButton<String>(
      items: _sizes.map((String dropDownStringItem) {
        return DropdownMenuItem<String>(
          value: dropDownStringItem,
          child: Text(dropDownStringItem),
        );
      }).toList(),
      onChanged: (String newValueSelected) {
          _currentItemSelected = newValueSelected;
          size = newValueSelected;
      },
      value: _currentItemSelected,
    ),
  );
}





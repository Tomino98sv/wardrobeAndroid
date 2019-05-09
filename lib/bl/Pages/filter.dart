import 'package:flutter/material.dart';

class FilterChipDisplay extends StatefulWidget {
  @override
   _FilterChipDisplayState createState() => _FilterChipDisplayState();
  }



class _FilterChipDisplayState extends State<FilterChipDisplay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            child: Wrap(
              spacing: 2.0,
              children: <Widget>[
                FilterChipWidget(chipName: 'Size',),
                FilterChipWidget(chipName: 'Length',),
                FilterChipWidget(chipName: 'Color',),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class FilterChipWidget extends StatefulWidget{
  final String chipName;

  FilterChipWidget({Key key, this.chipName}) : super(key: key);

  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget>{
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(color: Colors.black),
      selected: _isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Colors.white12,
      onSelected: (isSelected){
        setState(() {
          _isSelected = isSelected;
        });
      },
      selectedColor: Colors.pinkAccent,
    );
  }
}
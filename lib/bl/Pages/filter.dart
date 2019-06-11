import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/db/allDressesList.dart';

class FilterChipDisplay extends StatefulWidget {
  String _valueFilter;
  Function onFilterChosen;

  FilterChipDisplay({@required Function function}) {
    onFilterChosen = function;
  }

  @override
  _FilterChipDisplayState createState() => _FilterChipDisplayState();
}

var counter = 0;
bool selectedWidgetSize = false;
bool selectedWidgetLength = false;
bool selectedWidgetColor = false;

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
            style: Theme.of(context).textTheme.subhead,
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
                        selectedWidgetSize = !selectedWidgetSize;
                        selectedWidgetSize == true
                            ? showDialog(
                                context: context,
                                child: _buildSizeWidget(
                                    context, widget.onFilterChosen))
                            : widget.onFilterChosen(null);
                      });
                    },
                  ),
                  FilterChipWidget(
                      chipName: 'Length',
                      onPressed: () {
                        setState(() {
                          selectedWidgetLength = !selectedWidgetLength;
                          selectedWidgetLength == true
                              ? showDialog(
                                  context: context,
                                  child: _buildLenghtWidget(
                                      context, widget.onFilterChosen))
                              :widget.onFilterChosen(null);
                        });
                      }),
                  FilterChipWidget(
                      chipName: 'Color',
                      onPressed: () {
                        setState(() {
                          selectedWidgetColor = !selectedWidgetColor;
                          selectedWidgetColor == true
                              ? showDialog(
                                  context: context,
                                  child: _buildColorWidget(
                                      context, widget.onFilterChosen))
                              :widget.onFilterChosen(null);
                        });
                      }),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
}

String value;

class FilterChipWidget extends StatefulWidget {
  final String chipName;
  final Function onPressed;

  FilterChipWidget({Key key, this.chipName, this.onPressed}) : super(key: key);

  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName, style: Theme.of(context).textTheme.subhead),
      labelStyle: TextStyle(
          fontFamily: 'Pacifico', fontSize: 16.0, fontWeight: FontWeight.w400),
      selected: _isSelected,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: Colors.grey)),
      backgroundColor: Theme.of(context).indicatorColor,
      onSelected: (isSelected) {
        widget.onPressed();
        setState(() {
          _isSelected = isSelected;
          debugPrint("${isSelected}");
          if (isSelected) {
            counter++;
            debugPrint("$counter");
            selectedWidgetSize = true;
            selectedWidgetLength = true;
            selectedWidgetColor = true;
//           debugPrint("$selectedWidget");
          } else {
            debugPrint("neda to proste");
            AllDressesList(
              filterValue: null,
            );
          }
        });
      },
      selectedColor: Theme.of(context).buttonColor,
    );
  }
}

List<String> sizes = ['34', '36', '38', '40', '42', '44', '46', '48'];
int _currentItemSelected = 0;

Widget _buildSizeWidget(BuildContext context, Function func) {
  debugPrint("malo by vykreslit dropdown menu");
  return CupertinoAlertDialog(
    title: Text(
      "Your size: ",
      style: TextStyle(
          color: Colors.black,
          fontSize: 15.0,
          fontFamily: 'Pacifico',
          decorationStyle: TextDecorationStyle.dashed),
    ),
    content: SizedBox(
      width: 200,
      height: 200,
      child: CupertinoPicker(
          itemExtent: 30,
          diameterRatio: 1.0,
          backgroundColor: CupertinoColors.white,
          onSelectedItemChanged: (index) {
            _currentItemSelected = index;
            print(_currentItemSelected);
            value = sizes[index];
            print(value);
            func(value);
          },
          children: List<Widget>.generate(
            sizes.length,
            (index) {
              return Center(
                child: Text(
                  sizes[index],
                  style: TextStyle(
                      fontSize: 20.0, color: Theme.of(context).indicatorColor),
                ),
              );
            },
          )),
    ),
  );
}

List<String> lengths = ['Mini', 'Midi', 'Maxi', 'Oversize'];

Widget _buildLenghtWidget(BuildContext context, Function func) {
  debugPrint("malo by vykreslit dropdown menu 2");
  return CupertinoAlertDialog(
    title: Text(
      "Preferred length: ",
      style: TextStyle(
          color: Colors.black,
          fontSize: 15.0,
          fontFamily: 'Pacifico',
          decorationStyle: TextDecorationStyle.dashed),
    ),
    content: SizedBox(
      width: 200,
      height: 200,
      child: CupertinoPicker(
          itemExtent: 30,
          diameterRatio: 1.0,
          backgroundColor: CupertinoColors.white,
          onSelectedItemChanged: (index) {
            _currentItemSelected = index;
            print(_currentItemSelected);
            value = lengths[index];
            print(value);
            func(value);
          },
          children: List<Widget>.generate(
            lengths.length,
            (index) {
              return Center(
                child: Text(
                  lengths[index],
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                      fontSize: 20.0, color: Theme.of(context).indicatorColor),
                ),
              );
            },
          )),
    ),
  );
}

List<String> colors = [
  "Red",
  "Orange",
  "Yellow",
  "Green",
  "Blue",
  "Purple",
  "Brown",
  "Magenta",
  "Tan",
  "Cyan",
  "Olive",
  "Maroon",
  "Navy",
  "Aquamarine",
  "Turquoise",
  "Silver",
  "Lime",
  "Teal",
  "Indigo",
  "Violet",
  "Pink",
  "Black",
  "White",
  "Gray"
];

Widget _buildColorWidget(BuildContext context, Function func) {
  debugPrint("malo by vykreslit dropdown menu 3");
  return CupertinoAlertDialog(
    title: Text(
      "Preferred color: ",
      style: TextStyle(
        fontFamily: 'Pacifico',
          color: Colors.black,
          fontSize: 15.0,
          decorationStyle: TextDecorationStyle.dashed),
    ),
    content: SizedBox(
      width: 200,
      height: 200,
      child: CupertinoPicker(
          itemExtent: 30,
          diameterRatio: 1.0,
          backgroundColor: CupertinoColors.white,
          onSelectedItemChanged: (index) {
            _currentItemSelected = index;
            print(_currentItemSelected);
            value = colors[index];
            print(value);
            func(value);
          },
          children: List<Widget>.generate(
            colors.length,
            (index) {
              return Center(
                child: Text(
                  colors[index],
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                      fontSize: 20.0, color: Theme.of(context).indicatorColor),
                ),
              );
            },
          )),
    ),
  );
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:flutter_app/db/model/changeImageItem.dart';

class EditItem extends StatefulWidget {
  DocumentSnapshot item;

  EditItem({@required this.item});

  _State createState() => new _State(item: item);
}

class _State extends State<EditItem> {
  DocumentSnapshot item;

  _State({@required this.item}) {
    docName = item['name'];
    docColor = item['color'];
    docDescription = item['description'];
    docSize = item['size'];
    docLength = item['length'];
    if (item['request'] == 'borrow')
      docFunction = '';
    else if (item['request'] == 'buy')
      docFunction = "sell";
    else
      docFunction = item['request'];
    if (item['price']!=null)
      docPrice = item['price'];
    //   docImage = item['photo_url'];
  }

  String docName = '';
  String docColor = '';
  String docDescription = '';
  String docSize = '';
  String docLength = '';
  String docFunction = '';
  String docPrice = '';


  void _onChangedName(String value) {
    setState(() => docName = '$value');
  }

  void _onChangedColor(String value) {
    setState(() => docColor = '$value');
  }

  void _onChangedDescription(String value) {
    setState(() => docDescription = '$value');
  }

  void _onChangedSize(String value) {
    setState(() => docSize = '$value');
  }

  void _onChangedLength(String value) {
    setState(() => docLength = '$value');
  }

  void _onChangedFunction(String value) {
    setState(() {
      if (value == '-not selected-')
        docFunction = "";
      else
        docFunction = '$value';
    });
  }

  void _onChangedPrice(String value) {
    setState(() {
      docPrice = '$value';
    });
  }


//
//  void _onSubmit(String value) {
//    setState(() => docName = 'Submit: $value');
//  }

  var _sizes = ['34', '36', '38', '40', '42', '44', '46', '48'];
  var _colors = ["Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Brown", "Magenta", "Tan", "Cyan", "Olive", "Maroon", "Navy", "Aquamarine", "Turquoise", "Silver", "Lime", "Teal", "Indigo", "Violet", "Pink", "Black", "White", "Gray"];
  var _currentItemSelected = '38';
  var _length = ['Mini', 'Midi', 'Maxi', 'Oversize'];
  var _currentLengthSelected = 'Midi';
  var _currentColorSelected = "Black";
  var _functions = ['-not selected-', 'giveaway', 'sell'];
  var _currentFunctionSelected = '-not selected-';





  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Edit Item',
          style: TextStyle(
              color: Colors.white
          ),),
      ),
      body: SingleChildScrollView(
        child: new Container(
          padding: new EdgeInsets.all(32.0),
          child: new Center(
            child: new Column(
              children: <Widget>[
                Container(
                  width: 200.0,
                  height: 200.0,
                  child: new ZoomableWidget(
                    minScale: 1.0,
                    maxScale: 2.0,
                    // default factor is 1.0, use 0.0 to disable boundary
                    panLimit: 0.0,
                    bounceBackBoundary: true,
                    child: CachedNetworkImage(
                      imageUrl: item['photo_url'],
                      placeholder: (context, imageUrl) => CircularProgressIndicator(),
                    ),
//                      child: TransitionToImage(
//                        image: AdvancedNetworkImage(
//                          item['photo_url'],
//                          useDiskCache: true,
//                          cacheRule: CacheRule(maxAge: const Duration(days: 7)),
//                        ),
//                        placeholder: CircularProgressIndicator(),
//                        duration: Duration(milliseconds: 300),
//                      )),
                  ),),
                changeImageItem(item: item),
                new TextField(
                  style:Theme.of(context).textTheme.subhead,
                  decoration: new InputDecoration(
                      labelText: item['name'],
                      icon: new Icon(Icons.account_circle,
                          color: Theme.of(context).buttonColor)),
                  onChanged: _onChangedName,
                ),
                TextField(
                  style:Theme.of(context).textTheme.subhead,
                  decoration: new InputDecoration(
                      labelText: item['description'],
                      icon:
                      new Icon(Icons.event_note, color: Theme.of(context).buttonColor)),
                  onChanged: _onChangedDescription,
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.color_lens,
                        color: Theme.of(context).buttonColor),
                    Padding(padding: EdgeInsets.all(10.0)),
                    Expanded(
                      child: Text(
                          'Color:',style:Theme.of(context).textTheme.subhead
                      ),
                    ),
                    Expanded(
                      child: DropdownButton(
                          items: _colors.map((String dropDownStringItem){
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            );
                          }).toList(),
                          onChanged: (String newValueSelected) {
                            setState(() {
                              this._currentColorSelected = newValueSelected;
                              docColor = newValueSelected;
                            });
                            _onChangedColor(docColor);
                          },
                          //value: _currentItemSelected,
                          value: _currentColorSelected == item['color'].toString() ? item['color'].toString() : docColor
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.aspect_ratio,
                        color: Theme.of(context).buttonColor),
                    Padding(padding: EdgeInsets.all(10.0)),
                    Expanded(
                      child: Text(
                          'Size:',style:Theme.of(context).textTheme.subhead
                      ),
                    ),
                    Expanded(
                      child: DropdownButton(
                          items: _sizes.map((String dropDownStringItem){
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            );
                          }).toList(),
                          onChanged: (String newValueSelected) {
                            setState(() {
                              this._currentItemSelected = newValueSelected;
                              docSize = newValueSelected;
                            });
                            _onChangedSize(docSize);
                          },
                          //value: _currentItemSelected,
                          value: _currentItemSelected == item['size'].toString() ? item['size'].toString() : docSize
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.content_cut,
                          color: Theme.of(context).buttonColor),
                    Padding(padding: EdgeInsets.all(10.0)),
                    Expanded(
                      child: Text(
                          'Length:', style:Theme.of(context).textTheme.subhead
                      ),
                    ),
                    Expanded(
                      child: DropdownButton(
                          items: _length.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            );
                          }).toList(),
                          onChanged: (String newValueSelected) {
                            setState(() {
                              this._currentLengthSelected = newValueSelected;
                              docLength = newValueSelected;
                            });
                            _onChangedLength(docLength);
                          },
                          value: _currentLengthSelected == item['length'].toString() ? item['length'].toString() : docLength
//                        value: item['length'].toString(),
//                      value: _currentLengthSelected,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.business_center,
                          color: Theme.of(context).buttonColor),
                    Padding(padding: EdgeInsets.all(10.0)),
                    Expanded(
                      child: Text(
                          'Sell?:', style:Theme.of(context).textTheme.subhead
                      ),
                    ),
                    Expanded(
                      child: DropdownButton(
                          items: _functions.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            );
                          }).toList(),
                          onChanged: (String newValueSelected) {
                            setState(() {
                              this._currentFunctionSelected = newValueSelected;
                              if (newValueSelected == '-not selected-')
                                docFunction = "";
                              else
                                docFunction = newValueSelected;
                            });
                            _onChangedFunction(docFunction);
                          },
                          value: _currentFunctionSelected == item['request'].toString()
                              ? item['request'].toString()
                              : docFunction == ""
                              ? '-not selected-' : docFunction
//                        value: item['length'].toString(),
//                      value: _currentLengthSelected,
                      ),
                    ),
                  ],
                ),
                Container(
//                    child: (item['request'] == 'sell' || docFunction == 'sell')
                  child: (docFunction == 'sell')
                      ? Row(
                    children: <Widget>[
                      Icon(Icons.monetization_on, color: Theme.of(context).buttonColor),
                      Padding(padding: EdgeInsets.all(10.0)),
                      Expanded(
                        child: Text('Set price:',style:Theme.of(context).textTheme.subhead),
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          style:Theme.of(context).textTheme.subhead,
                          decoration: new InputDecoration(
                            labelText: item['price'],),
                          onChanged: _onChangedPrice,
                        ),
                      )
                    ],
                  ) : Container(),
                ),
                Container(
                  child: InkWell(
                    onTap:() {
                      if (docName != '') {
                        Firestore.instance
                            .collection('items')
                            .document(item.documentID)
                            .updateData({"name": docName});
                        debugPrint("zmenil som meno");
                      }
                      if (docColor != '') {
                        Firestore.instance
                            .collection('items')
                            .document(item.documentID)
                            .updateData({"color": docColor});
                        debugPrint("zmenil som farbu");
                      }
                      if (docDescription != '') {
                        Firestore.instance
                            .collection('items')
                            .document(item.documentID)
                            .updateData({"description": docDescription});
                        debugPrint("zmenil som description");
                      }
                      if (docSize != '') {
                        Firestore.instance
                            .collection('items')
                            .document(item.documentID)
                            .updateData({"size": docSize});
                        debugPrint("zmenil som velkost");
                      }
                      if (docLength != '') {
                        Firestore.instance
                            .collection('items')
                            .document(item.documentID)
                            .updateData({"length": docLength});
                        debugPrint("zmenil som dlzku");
                      }
//                        if (docFunction !=''){

//                        if(docFunction == 'sell' && item['request'].toString() == 'buy'){
                      if(docFunction == 'sell'){
                        debugPrint('teraz je tototoo');
                        var count = 0;
                        Firestore.instance.collection('requestBuy')
                            .where('respondent', isEqualTo: item['userId']).where('itemID', isEqualTo: item.documentID).getDocuments().then((foundDoc){
                          for (DocumentSnapshot ds in foundDoc.documents){
                            if (ds['respondent'] == item['userId']){
                              count++;
                            }
                          }

                          if (count!=0){
                            Firestore.instance
                                .collection('items')
                                .document(item.documentID)
                                .updateData({"request": 'buy'});
                            debugPrint("zmenul som funkciu/request");
                          }
                        });

                      } else if (item['request'].toString() != 'borrow' || docFunction!=''){
                        Firestore.instance
                            .collection('items')
                            .document(item.documentID)
                            .updateData({"request": docFunction});
                        debugPrint("zmenul som funkciu/request");
                      }
                      if (docPrice != '') {
                        Firestore.instance
                            .collection('items')
                            .document(item.documentID)
                            .updateData({"price": docPrice});
                        debugPrint("zmenil som cenu");
                      }
                      if (docFunction != 'sell'){
                        Firestore.instance
                            .collection('items')
                            .document(item.documentID)
                            .updateData({'price' : FieldValue.delete()});
                      }
                      Navigator.pop(context);},
                    child: Container(
                      decoration: new BoxDecoration(
                        color: Theme.of(context).buttonColor,
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      width: 100,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Send',
                        style: TextStyle(
                          color: Colors.white
                        ),),
                    ),),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
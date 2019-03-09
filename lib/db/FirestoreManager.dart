import 'package:flutter/material.dart';
import 'package:flutter_app/db/model/Item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(ItemsList());

class ItemsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('items').snapshots(), //shows items from Firebase
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                Item item = Item(
                  name: document['name'],
                  color: document['color'],
                  size: document['size'],
                  length: document['length'],
                  photoUrl: document['photo_url'],
                  id: document.documentID
                );
                return new ExpansionTile(
                  leading: item.photoUrl == null || item.photoUrl == ""
                      ? Icon(Icons.accessibility)
                      : Image.network(
                          item.photoUrl,
                          height: 42,
                          width: 42),
                  title: new Text(item.name),
//                  subtitle: new Text(document['color']),
                  children: <Widget>[
                    new Text("Name: ${item.name}"),
                    new Text("Color: ${item.color}"),
                    new Text("Size: ${item.size}"),
                    new Text("Length: ${item.length}"),
                    new RaisedButton(
                        child: Text("Edit"),
                        color: Colors.pinkAccent,
                        elevation: 4.0,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return SecondRoute(item: document);
//                            return SecondRoute(item: document); //tu je predchadzajuci kod
                          }));
                          debugPrint("idem dalej");
                        }),
                  ],
                );
              }).toList(),

            );
        }
      },
    );
  }
}

class SecondRoute extends StatefulWidget{

  DocumentSnapshot item;
  SecondRoute({@required this.item});
  _State createState() => new _State(item: item);

}

class _State extends State<SecondRoute>{

  DocumentSnapshot item;
  _State({@required this.item});

  String docName = "";

  void _onChanged(String value) {
    setState(() => docName = 'Change: $value');
  }\


  void _onSubmit(String value) {
    setState(() => docName = 'Submit: $value');
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Edit Item'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Text(docName),
              new TextField(
                decoration: new InputDecoration(labelText: 'Hello', hintText: 'Hint',
                icon: new Icon(Icons.people)),
                onChanged: _onChanged,
                onSubmitted: _onSubmit,
              ),
              RaisedButton(
                child: Text('Send'),
                onPressed: () {
                  Firestore.instance.collection('items').document(item.documentID) //upravit na ozajstne premenne
//                    .updateData({"color": item['color'], "name": item['name']});
                    .updateData({"name": docName});
                debugPrint("zmenil sooooooom");
                Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

}


//class SecondRoute extends StatelessWidget {
//  DocumentSnapshot item;
//
//  SecondRoute({@required this.item});
//  @override
//  Widget build(BuildContext context) {
//
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Edit Item"),
//      ),
//
//      body: Center(
//        child: Column(
//          children: <Widget>[
//            Image.network(
//                item['photo_url'],
//                height: 120,
//                width: 120),
//            RaisedButton(
//              child: Text("Edit Photo"),
//              color: Colors.pinkAccent,
//              elevation: 4.0,
//              onPressed: (){
//                //kod
//              },
//            ),
//            Text('Name: '),
//            TextField(
//              decoration: InputDecoration.collapsed(hintText: item['name']),
//              onChanged: (value) => {
//                item['name'] : value
//            },),
//            TextFormField(decoration: InputDecoration.collapsed(
//                hintText: item['name']),),
//            Text('Color: '),
//            TextFormField(decoration: InputDecoration.collapsed(
//                hintText: item['color']),),
//            Text('Size: '),
//            TextFormField(decoration: InputDecoration.collapsed(
//                hintText: item['size']),),
//            Text('Length: '),
//            TextFormField(decoration: InputDecoration.collapsed(
//                hintText: item['length'],),),
//            RaisedButton(
//              child: Text('Submit'),
//              color: Colors.pinkAccent,
//              elevation: 4.0,
//              onPressed: () {
//                //submit changes to database
//                Firestore.instance.collection('items').document(item.documentID) //upravit na ozajstne premenne
////                    .updateData({"color": item['color'], "name": item['name']});
//                    .updateData({"color": "bezova"});
//                debugPrint("zmenil sooooooom");
//                Navigator.pop(context);
//              },
//            )
//          ],
//        ),
//      ),
//    );
//
//  }
//}

class Item {
  var name;
  var color;
  var size;
  var length;
  var photoUrl;
  var id;

  Item({this.name, this.color, this.size, this.length, this.photoUrl, this.id});

}



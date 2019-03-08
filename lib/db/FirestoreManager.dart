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
                  length: document['length']
                );
                return new ExpansionTile(
                  leading: document['photo_url'] == null || document['photo_url'] == ""
                      ? Icon(Icons.accessibility)
                      : Image.network(
                          document['photo_url'],
                          height: 42,
                          width: 42),
                  title: new Text(document['name']),
//                  subtitle: new Text(document['color']),
                  children: <Widget>[
                    new Text("Name: "+item.name),
                    new Text("Color: "+item.color),
                    new Text("Size: "+item.size),
                    new Text("Length: "+item.length),
                    new RaisedButton(
                        child: Text("Edit"),
                        color: Colors.pinkAccent,
                        elevation: 4.0,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return SecondRoute(item: document);
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

class SecondRoute extends StatelessWidget {
  DocumentSnapshot item;

  SecondRoute({@required this.item});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Item"),
      ),

      body: Center(
        child: Column(
          children: <Widget>[
            Image.network(
                item['photo_url'],
                height: 120,
                width: 120),
            RaisedButton(
              child: Text("Edit Photo"),
              color: Colors.pinkAccent,
              elevation: 4.0,
              onPressed: () {
                //kod ktory moze menit fotku (upload)
              },
            ),
            Text('Name: '),
            TextFormField(decoration: InputDecoration.collapsed(
                hintText: item['name']),),
            Text('Color: '),
            TextFormField(decoration: InputDecoration.collapsed(
                hintText: item['color']),),
            Text('Size: '),
            TextFormField(decoration: InputDecoration.collapsed(
                hintText: item['size']),),
            Text('Length: '),
            TextFormField(decoration: InputDecoration.collapsed(
                hintText: item['length'],),),
            RaisedButton(
              child: Text('Submit'),
              color: Colors.pinkAccent,
              elevation: 4.0,
              onPressed: () {
                //submit changes to database
                Firestore.instance.collection('items').document('-LZeCfJfygxm7wZz2PAW') //upravit na ozajstne premenne
//                    .updateData({"color": item['color'], "name": item['name']});
                    .updateData({"color": "aaaaaaa"});
                debugPrint("zmenil sooooooom");
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );

  }
}

class Item {
  var name;
  var color;
  var size;
  var length;
  var photoUrl;

  Item({this.name, this.color, this.size, this.length, this.photoUrl});

}



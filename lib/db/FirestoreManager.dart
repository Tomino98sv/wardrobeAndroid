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
                    new Text("Name: "+document['name']),
                    new Text("Color: "+document['color']),
                    new Text("Size: "+document['size']),
                    new Text("Length: "+document['length']),
                    new RaisedButton(
                        child: Text("Edit"),
                        color: Colors.pinkAccent,
                        elevation: 4.0,
                        onPressed: () {
                          //zakomentovat kod, lebo pise exception
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return MyNewItem();
                          }));
                          debugPrint("idem dalej");
                        }),
//                            () => modifyItem(document['name'],document['color'], document['size'], document['length'])),
                  ],
                );
              }).toList(),

            );
        }
      },
    );
  }
  void modifyItem(name, color, size, length) {

  }
}




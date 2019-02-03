import 'package:flutter/material.dart';
import 'package:flutter_app/db/model/Item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(DatabaseList());
//void main() => runApp(getListView());

class DatabaseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'My dresses';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this would produce 2 rows.
          crossAxisCount: 2,
          // Generate 100 Widgets that display their index in the List
          children: List.generate(1, (index) { //tu treba dokoncit aby topekne ukazovalo vedla seba
            return Center(
              child: ItemsList(),
            );
          }),
        ),
      ),
    );
  }
}

Widget getListView(i) {
  var listView = ListView(
    children: <Widget>[
      ListTile(
        leading: Icon(Icons.redeem),
        title: Text("Dress $i"),
        subtitle: Text("Floral Dress"),
        trailing: Icon(Icons.accessibility),
        onTap: (){
          debugPrint("Tapped $i");
        },
      )
    ],
  );

  return listView;
}

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
                return new ListTile(
                  leading: Icon(Icons.redeem),
                  title: new Text(document['name']),
                  subtitle: new Text(document['color']),
                  trailing: Icon(Icons.accessibility),
                  onTap: (){ //tu napisem co sa stane, ked klikne user na item- prejde k detailom
                    debugPrint("Tapped");
                  },
                );
              }).toList(),
            );
        }
      },
    );
  }
}


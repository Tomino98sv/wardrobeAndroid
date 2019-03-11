import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
                return Slidable(
                  delegate: new SlidableDrawerDelegate(),
                  actionExtentRatio: 0.25,
                  child: new ExpansionTile(
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
                                return SecondRoute(item: item);
//                            return SecondRoute(item: document); //tu je predchadzajuci kod
                              }));
                              debugPrint("idem dalej");
                            }),
                      ],
                    ),
                  secondaryActions: <Widget>[
                    new IconSlideAction(
                      icon: Icons.transfer_within_a_station,
                      caption: 'Delete',
                      color: Colors.red,
                      onTap: () {
                        debugPrint('klikol som');
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete Item'),
                              content: Text('Are you sure you want to delete this item?'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Yes'),
                                  onPressed: (){
                                    Firestore.instance.collection('items').document(item.id).delete();
                                    Navigator.pop(context);
                                    debugPrint("vymazanee");
                                  },
                                ),
                                FlatButton(
                                  child: Text('Cancel'),
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          },
                        );

                      },
                    ),
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

  Item item;
  SecondRoute({@required this.item});
  _State createState() => new _State(item: item);

}

class _State extends State<SecondRoute>{

  Item item;
  _State({@required this.item});

  String docName = '';
  String docColor = '';
  String docSize = '';
  String docLength = '';

  void _onChangedName(String value) {
    setState(() => docName = '$value');
  }

  void _onChangedColor(String value) {
    setState(() => docColor = '$value');
  }

  void _onChangedSize(String value) {
    setState(() => docSize = '$value');
  }

  void _onChangedLength(String value) {
    setState(() => docLength = '$value');
  }

//
//  void _onSubmit(String value) {
//    setState(() => docName = 'Submit: $value');
//  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Edit Item'),
      ),
      body: SingleChildScrollView(
        child: new Container(
          padding: new EdgeInsets.all(32.0),
          child: new Center(
            child: new Column(
              children: <Widget>[
                Image.network(
                      item.photoUrl,
                      height: 120,
                      width: 120),
                new TextField(
                  decoration: new InputDecoration(labelText: item.name,
                  icon: new Icon(Icons.account_circle)),
                  onChanged: _onChangedName,
                ),
                new TextField(
                  decoration: new InputDecoration(labelText: item.color,
                      icon: new Icon(Icons.color_lens)),
                  onChanged: _onChangedColor,
                ),
                new TextField(
                  decoration: new InputDecoration(labelText: item.size,
                      icon: new Icon(Icons.aspect_ratio)),
                  onChanged: _onChangedSize,
                ),
                new TextField(
                  decoration: new InputDecoration(labelText: item.length,
                      icon: new Icon(Icons.content_cut)),
                  onChanged: _onChangedLength,
                ),
                RaisedButton(
                  child: Text('Send'),
                  onPressed: () {
                    if (docName != '') {
                      Firestore.instance.collection('items').document(item.id)
                          .updateData({"name": docName});
                      debugPrint("zmenil som meno");
                    }
                    if (docColor != '') {
                      Firestore.instance.collection('items').document(item.id)
                          .updateData({"color": docColor});
                      debugPrint("zmenil som farbu");
                    }
                    if (docSize != '') {
                      Firestore.instance.collection('items').document(item.id)
                          .updateData({"size": docSize});
                      debugPrint("zmenil som velkost");
                    }
                    if (docLength != '') {
                      Firestore.instance.collection('items').document(item.id)
                          .updateData({"length": docLength});
                      debugPrint("zmenil som dlzku");
                    }
                  Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
class ItemsListSearch extends SearchDelegate<ItemsList>{
  var items = Firestore.instance.collection('items').snapshots();

  ItemsListSearch(this.items);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
       icon: Icon(Icons.clear),
        onPressed: (){
         query ='';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return
      IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          close(context, null);
        },

    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: items,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(
              child: Text("No  data"),
            );
          }
          final results =
          snapshot.data.documents.where((a) => a['name'].toLowerCase().contains(query));

          return ListView(
            children: results.map((DocumentSnapshot document) {
              Item item = Item(
                  name: document['name'],
                  color: document['color'],
                  size: document['size'],
                  length: document['length'],
                  photoUrl: document['photo_url'],
                  id: document.documentID
              );
            },
            ).toList()
            ,);
        }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: items,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(
              child: Text("No  data"),
            );
          }
          final results =
          snapshot.data.documents.where((a) => a['name'].startsWith(query)).toList();
          //a.documentID.toLowerCase().contains(query));
          return ListView(
            children: results
                .map<ListTile>((a) => ListTile(
              title: Text(a['name'],
                style: Theme.of(context).textTheme.subhead.copyWith(
                    fontSize: 12.0,
                    color: Colors.pink,
                )),
//              onTap: (){
//                close(context, a);
//              },
          )).toList(),
          );
        },
    );

}

}

class Item {
  var name;
  var color;
  var size;
  var length;
  var photoUrl;
  var id;

  Item({this.name, this.color, this.size, this.length, this.photoUrl, this.id});

}



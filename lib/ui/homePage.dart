import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bl/Pages/rating.dart';
import 'package:flutter_app/bl/Pages/settingsPage.dart';
import 'package:flutter_app/bl/Pages/welcome.dart';
import 'package:flutter_app/bl/mainLoginPage.dart';
import 'package:flutter_app/bl/videjko/services/usermanagment.dart';
import 'package:flutter_app/db/FirestoreManager.dart';
import 'package:flutter_app/db/allDressesList.dart';
import 'package:flutter_app/deals/dealsHome.dart';
import 'package:flutter_app/notif/notifications.dart';
import 'package:flutter_app/ui/themes.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:badges/badges.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

//preklikavanie v navigation bar
class _HomeState extends State<HomePage> {

  int _page = 0;
  UserManagement userManagement = new UserManagement();
  ThemeSwitcher inheritedThemeSwitcher;
  FirebaseUser user;
  bool themeChosen;
  bool themeDarkChosen;
  var rateInit=null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getActiveTheme();
    FirebaseAuth.instance.currentUser().then((fUser) {
      user = fUser;
      Stream<QuerySnapshot> snapshot = Firestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .snapshots();

      snapshot.listen((QuerySnapshot data){
        rateInit = data.documents[0]['rating'];
        if(rateInit==null){
          Future.delayed(Duration(seconds: 3), () {
            rating(context,"Rating", "Rate the app, please");
          });
          rateInit=-1;
        }else{
          rateInit=-1;
          //to je preto aby sa nasa 200-krat prekreslovana apka nepytala dokolecka usera dokym do uklada na server
        }
      });
    });
  }

  final _options = [
    WelcomePage(),
    AllDressesList(key: new GlobalKey<DressesListState>()),
    NotificationsPage(),
    DealsPage(),
    UserListHome()
  ];

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    inheritedThemeSwitcher = ThemeSwitcher.of(context);
    return WillPopScope(
      onWillPop: () {
        confirm(context, "Leave the app",
            "Log out and leave the app!");
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('eDresses',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Pacifico'),
          ),
          actions: <Widget>[
            _page != 4
                ? Container()
                : IconButton(
                    icon: Icon(Icons.search, color: Colors.white,),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: UserListSearch(
                            Firestore.instance.collection('users').snapshots()),
                      );
                    },
                  ),
            _page != 1
                ? Container()
                : IconButton(
                    icon: Icon(Icons.search,color: Colors.white,),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: ItemsListSearch(
                            Firestore.instance.collection('items').snapshots()),
                      );
                    },
                  ),
            _page != 1
                ? Container()
                : IconButton(
                    icon: Icon(Icons.filter_list, color: Colors.white,),
                    onPressed: () {
                      GlobalKey key = (_options[_page] as AllDressesList).key;
                      DressesListState state =
                          key.currentState as DressesListState;
                      state.setState(() {
                        state.showFilters = !state.showFilters;
                        if(!state.showFilters) {
                          state.filterValue = null;
                        }
                      });
                    }),
          ],
        ),
        body: Container(
          child: _options.elementAt(_page),
          //sirka, vyska, child do childu podmienku - uz netreba pravdepodobne
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).buttonColor,
          child: Container(
            height: 88.2,
            child: Column(
              children: <Widget>[
                Flexible(
                child: Text("Tu by mohla byt aktualna sprava prichadzajuca",
                style: Theme.of(context).textTheme.subtitle),
            ),
                BottomNavigationBar(
                  type: BottomNavigationBarType.shifting,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: new Icon(Icons.face, color: Colors.black),
                      title: new Text('Me',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Pacifico',
                        ),),
                      activeIcon: new Icon(Icons.face, color: Theme.of(context).buttonColor)
                      ),
                    BottomNavigationBarItem(
                      icon: new Icon(Icons.style, color: Colors.black),
                      title: new Text('Dresses',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Pacifico',
                        ),),
                        activeIcon: new Icon(Icons.style, color:Theme.of(context).buttonColor)
                    ),
                    BottomNavigationBarItem(
                      icon: Badge(
                        badgeContent: Text('3'),
                        child: new Icon(Icons.notifications, color: Colors.black),
                      ),
                      title: new Text('Alerts',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Pacifico',
                        ),),
                        activeIcon: new Icon(Icons.notifications, color: Theme.of(context).buttonColor)
                    ),
                    BottomNavigationBarItem(
                      icon: new Icon(Icons.shopping_cart, color: Colors.black),
                      title: new Text('Deals',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Pacifico'),),
                        activeIcon: new Icon(Icons.shopping_cart, color: Theme.of(context).buttonColor)
                    ),
                    BottomNavigationBarItem(
                        icon: new Icon(Icons.account_circle, color:Colors.black),
                        title: new Text('Users',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Pacifico',
                          ),),
                        activeIcon: new Icon(Icons.account_circle, color: Theme.of(context).buttonColor)
                    )

                  ],
                  currentIndex: _page,
                  onTap: onPageChanged,
                ),
              ],
            )
          ),
        )
      ),
    );
  }

  void choiceAction(String choice) {
    GoogleSignIn _googleSignIn;
    _googleSignIn?.signOut();
    if (choice == Constants.Settings) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => SettingsPage()));
    } else if (choice == Constants.LogOut) {
      FirebaseAuth.instance.signOut().then((value) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => QuickBee()),
            (Route<dynamic> route) => false);
      }).catchError((e) {
        print(e);
      });
    }
  }

  confirm(BuildContext context, String title, String description) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text(description, style: TextStyle(color: Colors.black),)],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: signOut,
                child: Text("Log Out"),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Stay Here"),
              )
            ],
          );
        });
  }

  rating(BuildContext context, String title, String description) {

    int rating=5;

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))
            ),
            title: Text(title),
            content: SingleChildScrollView(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return StarRating(
                    onChanged: (index) {
                      setState(() {
                        rating = index;
                      });
                    },
                    value: rating,
                  );
                },
              ),
            ),
            actions: <Widget>[

              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: TextStyle(color: Colors.black),),
              ),
              Padding(
                  padding: EdgeInsets.only(right: 55.0)
              ),

              FlatButton(
                onPressed: () => rate(rating,context),
                child: Text("Submit", style: TextStyle(color: Colors.black)),
              ),
              Padding(
                  padding: EdgeInsets.only(right: 35.0)
              ),
            ],
          );
        });
  }

  rate(int value, BuildContext context){
    userManagement.sendRating(value).then((complete){
      Navigator.pop(context);
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text("Thanks for your rating"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))
              ),
              content: SingleChildScrollView(
                child: Icon(Icons.toys,color: Theme.of(context).accentColor),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Done"),
                  padding: EdgeInsets.only(right: 50.0),
                ),
              ],
            );
          });
    });
  }

  signOut() {
    GoogleSignIn _googleSignIn;
    _googleSignIn?.signOut();
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context, rootNavigator: true).pop('dialog');

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => QuickBee()),
          (Route<dynamic> route) => false);
    }).catchError((e) {
      print(e);
    });
  }

  void getActiveTheme(){
    FirebaseAuth.instance.currentUser().then((fUser) {
      setState(() {
        user = fUser;
        Stream<QuerySnapshot> snapshot = Firestore.instance
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .snapshots();

        snapshot.listen((QuerySnapshot data){
          themeChosen = data.documents[0]['theme'];
          themeDarkChosen = data.documents[0]['darkTheme'];
          if(themeDarkChosen==true){
            darkMode(themeDarkChosen);
          }else {
            debugPrint("ThemeChosen: ${themeChosen}");
            changingColor(themeChosen);
          }
        });
      });
    });
  }

  DemoTheme _buildPinkTheme() {
    return DemoTheme(
        'pink',
        new ThemeData(
          primaryColor: Colors.pink[400],
          scaffoldBackgroundColor: Colors.grey[50],
          accentColor: Colors.pink[400],
          buttonColor: Colors.pink,
          fontFamily: 'Pacifico',
          indicatorColor: Colors.pink[100],
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(
              subhead: TextStyle(color: Colors.black,),
              subtitle: TextStyle(color: Colors.white)),
        ));
  }

  DemoTheme _buildBlueTheme() {
    return DemoTheme(
        'blue',
        new ThemeData(
            primaryColor: Colors.blue[400],
            scaffoldBackgroundColor: Colors.grey[50],
            accentColor: Colors.blueAccent[400],
            buttonColor: Colors.blue,
            toggleableActiveColor: Colors.lightBlue,
            unselectedWidgetColor: Colors.blueAccent,
            fontFamily: 'Pacifico',
            indicatorColor: Colors.blue[200],
            brightness: Brightness.light,
            textTheme: TextTheme(
                subhead: TextStyle(color: Colors.black,),
                subtitle: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.black)
        ));
  }

  DemoTheme _buildDarkMode() {
    return DemoTheme(
        'dark',
        new ThemeData(
          textTheme: TextTheme(
            subhead: TextStyle(color: Colors.white),
              subtitle: TextStyle(color: Colors.black)
          ),
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.grey[900],
          accentColor: Colors.black45,
          buttonColor: Colors.white12,
          toggleableActiveColor: Colors.black54,
          unselectedWidgetColor: Colors.black45,
          fontFamily: 'Pacifico',
          canvasColor: Colors.black54,
          indicatorColor: Colors.black54,
          dialogBackgroundColor: Colors.black54,
          iconTheme: IconThemeData(color: Colors.white),
        ));
  }

  void changingColor(bool valueOfClick){
    setState(() {
      if(valueOfClick){
        inheritedThemeSwitcher.themeBloc.selectedTheme.add(_buildBlueTheme());
      } else {
        inheritedThemeSwitcher.themeBloc.selectedTheme.add(_buildPinkTheme());
      }
    });
  }

  void darkMode(bool valueOfMode){
    setState(() {
      if(valueOfMode){
        inheritedThemeSwitcher.themeBloc.selectedTheme.add(_buildDarkMode());
        }
    });
  }

}

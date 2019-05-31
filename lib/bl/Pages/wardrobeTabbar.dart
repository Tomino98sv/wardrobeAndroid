import 'package:flutter/material.dart';

class WardrobeTabBar extends StatefulWidget {
  final TabController tabController;

  const WardrobeTabBar({Key key, @required this.tabController})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _WardrobeTabBarState(tabController);
}

class _WardrobeTabBarState extends State<WardrobeTabBar> {
  final TabController _tabController;

  _WardrobeTabBarState(this._tabController);


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      children: <WardrobeTab>[
        WardrobeTab(
          textW: Container(
            width: width/4.5,
            child: Row(
              children: <Widget>[
                Text("My ", style: TextStyle(color: Colors.white, ),),
                Icon(Icons.style, color: Colors.white)
              ],
            ),
          ),
          position: 0,
          controller: _tabController,
        ),
        WardrobeTab(
          textW: Container(
            width: width/4.5,
            child: Row(
              children: <Widget>[
                Text("Lent ", style: TextStyle(color: Colors.white),),
                Icon(Icons.style,color: Colors.white)
              ],
            ),
          ),
          position: 1,
          controller: _tabController,
        ),
        WardrobeTab(
          textW: Container(
            width: width/4.5,
            child: Row(
              children: <Widget>[
                Text("Borrowed ", style: TextStyle(color: Colors.white)),
                Icon(Icons.style, color: Colors.white,)
              ],
            ),
          ),
          position: 2,
          controller: _tabController,
        ),
      ],
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}

class WardrobeTab extends StatefulWidget {
//  final String text;
  final int position;
  final TabController controller;
  final Widget textW;

  WardrobeTab({this.textW, this.position, this.controller});

  @override
  State<StatefulWidget> createState() =>
      _WardrobeTabState(textW,  controller, position);
}

class _WardrobeTabState extends State<WardrobeTab> {
  Widget text;
  bool _selected = false;
  TabController _controller;
  int _position;

  _WardrobeTabState(this.text, TabController controller, this._position) {
    _controller = controller;
    _controller.addListener(_handleScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
        child: Material(
          color: _selected ? Theme.of(context).indicatorColor: Theme.of(context).accentColor,
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
          child: InkWell(
            onTap: () {
              setState(() {
                _controller.animateTo(_position);
              });
            },
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: text
//              Text(
//                text,
//                style: TextStyle(
//                  fontSize: 16.0,
//                  color: _selected ? Colors.white : Colors.white,
//                ),
//              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleScroll() {
    if (!mounted) return;
    setState(() {
      _selected = _position == _controller.index;
    });
  }
}

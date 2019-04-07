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
    return Row(
      children: <WardrobeTab>[
        WardrobeTab(
          text: 'My Items',
          position: 0,
          controller: _tabController,
        ),
        WardrobeTab(
          text: 'Borrowed To',
          position: 1,
          controller: _tabController,
        ),
        WardrobeTab(
          text: 'Lend From',
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
  final String text;
  final int position;
  final TabController controller;

  WardrobeTab({this.text, this.position, this.controller});

  @override
  State<StatefulWidget> createState() =>
      _WardrobeTabState(text,  controller, position);
}

class _WardrobeTabState extends State<WardrobeTab> {
  String text;
  bool _selected = false;
  TabController _controller;
  int _position;

  _WardrobeTabState(this.text, TabController controller, this._position) {
    _controller = controller;
    _controller.addListener(_handleScroll);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
      child: Material(
        color: _selected ? Theme.of(context).accentColor: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
        child: InkWell(
          onTap: () {
            setState(() {
              _controller.animateTo(_position);
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20.0,
                color: _selected ? Colors.white : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleScroll() {
    setState(() {
      _selected = _position == _controller.index;
    });
  }
}

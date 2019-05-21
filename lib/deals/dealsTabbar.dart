import 'package:flutter/material.dart';

class DealsTabbar extends StatefulWidget {
  final TabController tabController;

  const DealsTabbar({Key key, @required this.tabController})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DealsTabbarState(tabController);
}

class _DealsTabbarState extends State<DealsTabbar> {
  final TabController _tabController;

  _DealsTabbarState(this._tabController);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <DealsTab>[
        DealsTab(
          text: 'Borrow',
          position: 0,
          controller: _tabController,
        ),
        DealsTab(
          text: 'Sell',
          position: 1,
          controller: _tabController,
        ),
        DealsTab(
          text: 'Giveaway',
          position: 2,
          controller: _tabController,
        ),
      ],
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}

class DealsTab extends StatefulWidget {
  final String text;
  final int position;
  final TabController controller;

  DealsTab({this.text, this.position, this.controller});

  @override
  State<StatefulWidget> createState() =>
      _DealsTabState(text,  controller, position);
}

class _DealsTabState extends State<DealsTab> {
  String text;
  bool _selected = false;
  TabController _controller;
  int _position;

  _DealsTabState(this.text, TabController controller, this._position) {
    _controller = controller;
    _controller.addListener(_handleScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
        child: Material(
          color: _selected ? Theme.of(context).buttonColor: Theme.of(context).indicatorColor,
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
          child: InkWell(
            onTap: () {
              setState(() {
                _controller.animateTo(_position);
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 20.0,
                  color: _selected ? Colors.white : Colors.white,
                ),
              ),
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

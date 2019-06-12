import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final void Function(int index) onChanged;
  final int value;
  final IconData filledStar;
  final IconData unfilledStar;

  const StarRating({
    Key key,
    @required this.onChanged,
    this.value=0,
    this.filledStar,
    this.unfilledStar,
  })  : assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).accentColor;
    final size = 35.0;
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          children: List.generate(5, (index) {
            return Flexible(
              child: IconButton(
                onPressed: onChanged != null
                    ? () {
                  onChanged(value == index + 1 ? index : index + 1);
                }
                    : null,
                color: index < value ? color : Colors.black,
                iconSize: size,
                icon: Icon(
                  index < value ? filledStar ?? Icons.star : unfilledStar ?? Icons.star_border,
                ),
                padding: EdgeInsets.zero,
                tooltip: "${index + 1} of 5",
              ),
            );
          }),
        ),
        Text(wordRate(value), style: TextStyle(color: Colors.black),)
      ],
    );
  }

  String wordRate(int value){
    String word="";
    word= value==0?"Horrible app":
          value==1?"Boring app":
          value==2?"I have seen better apps":
          value==3?"I am good with it":
          value==4?"Woow! Great app!":
          value==5?"Awesome app!":"nuuula";
    return word;
  }
}
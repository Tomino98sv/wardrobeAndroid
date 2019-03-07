import 'package:flutter/material.dart';
import 'package:flutter_app/ui/homePage.dart';

void main(){
  runApp( MaterialApp(
      title: "Dress",
      home: HomePage(),
      theme: ThemeData(
        primaryColor: Colors.pink,
      )
  )
  );
}
        /*
        color: Colors.white,
        color: Color(getColorHexFromStr('#FDD148')),
        color: Color(getColorHexFromStr('#FEE16D')).withOpacity(0.4)),
        color: isFavorite ? Colors.grey.withOpacity(0.2) : Colors.white),
        indicatorColor: Colors.yellow,
        height: 250.0,
        width: 400.0,
        width: double.infinity,
        width: MediaQuery.of(context).size.width - 120.0),
        width: MediaQuery.of(context).size.width / 4,
        bottom: 50.0,
        right: 100.0,
        left: 150.0,
        border: InputBorder.none,
        borderRadius: BorderRadius.circular(200.0),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        alignment: Alignment.topLeft,
        alignment: Alignment.topRight,
        textAlign: TextAlign.left,
        style: BorderStyle.solid,
        image: AssetImage('assets/wardrobe.jpg'),
        image: AssetImage(imgPath),
        fit: BoxFit.cover,
        icon: Icon(Icons.menu),
        icon: Icon(Icons.event_seat, color: Colors.grey),
        icon: Icon(Icons.timer, color: Colors.grey),
        icon: Icon(Icons.shopping_cart, color: Colors.grey),
        icon: Icon(Icons.person_outline, color: Colors.grey),
        iconSize: 30.0,
        contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
        padding: EdgeInsets.only(left: 15.0),
        padding: const EdgeInsets.only(left: 15.0),
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
        hintText: 'Search',
        'wardrobe',
        '\$248',
        fontWeight: FontWeight.bold),
        fontFamily: 'Quicksand',
        fontSize: 30.0,
        size: 30.0,
        elevation: 5.0,
        elevation: isFavorite ? 0.0 : 2.0,
        itemCard('wardrobe', 'assets/picture1.jpg', false),
        itemCard('wardrobe', 'assets/picture2.jpg', true),
        controller: controller,
        title,
        child: isFavorite ? Icon(Icons.favorite_border) : Icon(Icons.favorite, color: Colors.red),
        */

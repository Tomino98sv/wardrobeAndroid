import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class DemoTheme {
  final String name;
  final ThemeData data;

  const DemoTheme(this.name, this.data);
}

class ThemeBloc {
  final Stream<ThemeData> themeDataStream;
  final Sink<DemoTheme> selectedTheme;

  factory ThemeBloc() {
    // ignore: close_sinks
    final selectedTheme = PublishSubject<DemoTheme>();
    final themeDataStream = selectedTheme
        .distinct()
        .map((theme) => theme.data);
    return ThemeBloc._(themeDataStream, selectedTheme);
  }

  const ThemeBloc._(this.themeDataStream, this.selectedTheme);

  DemoTheme initialTheme() {
    return DemoTheme(
        'initial',
        ThemeData(
  primaryColor: Colors.pink[400],
  scaffoldBackgroundColor: Colors.grey[50],
  accentColor: Colors.pink[400],
  buttonColor: Colors.pink,
  fontFamily: 'Quicksand',
  indicatorColor: Colors.blueGrey,
        ));
  }
}
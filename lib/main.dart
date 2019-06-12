import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/bl/nutused/home.dart';
import 'package:flutter_app/bl/Pages/welcome.dart';
import 'package:flutter_app/bl/mainLoginPage.dart';
import 'package:flutter_app/bl/nutused/hisMain.dart';
import 'package:flutter_app/bl/videjko/signUpPage.dart';
import 'package:flutter_app/ui/homePage.dart';
import 'package:flutter_app/ui/themes.dart';
import 'package:flutter/material.dart';

void main(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final ThemeBloc themeBloc = ThemeBloc();
    return ThemeSwitcher(
      themeBloc: themeBloc,
      // ignore: duplicate_import
      child: StreamBuilder<ThemeData>(
        initialData: themeBloc.initialTheme().data,
        stream: themeBloc.themeDataStream,
        builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Dress",
//        home: HomePage(),
            theme: snapshot.data,
            home: QuickBee(),
            routes: <String, WidgetBuilder>{
              '/landingpage': (BuildContext context) => new MyApp(),
              '/signup': (BuildContext context) => new SignupPage(),
              '/homepage': (BuildContext context) => new HomePage(),
              '/MainBee': (BuildContext context) => new QuickBee(),
              '/welcome': (BuildContext context) => new WelcomePage(),
                  },
               );
            }
         ),
    );
    }
}



class ThemeSwitcher extends InheritedWidget {
  final ThemeBloc themeBloc;

  const ThemeSwitcher({Key key, @required Widget child, this.themeBloc})
      : super(key: key, child: child);

  static ThemeSwitcher of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ThemeSwitcher);
  }

  @override
  bool updateShouldNotify(ThemeSwitcher oldWidget) =>
      oldWidget.themeBloc != themeBloc;
}

import 'package:flutter/material.dart';
import 'package:fluttervalidation/src/blocs/provider.dart';
import 'package:fluttervalidation/src/pages/home_page.dart';
import 'package:fluttervalidation/src/pages/login_page.dart';
import 'package:fluttervalidation/src/pages/producto_page.dart';
import 'package:fluttervalidation/src/pages/registro_page.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'registro': (BuildContext context) => RegistroPage(),
          'home': (BuildContext context) => HomePage(),
          'producto': (BuildContext context) => ProductPage()
        },
        theme: ThemeData(primaryColor: Colors.purpleAccent),
      ),
    );
  }
}

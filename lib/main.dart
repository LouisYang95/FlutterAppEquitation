import 'package:flutter/material.dart';

import 'package:flutter_app_equitation/Pages/bonus_page.dart';
import 'package:flutter_app_equitation/Pages/class_page.dart';


// Import all pages
import 'package:flutter_app_equitation/Pages/home_page.dart';
import 'package:flutter_app_equitation/Pages/login_page.dart';
import 'package:flutter_app_equitation/Pages/register_page.dart';
import 'package:flutter_app_equitation/Pages/bonus_page.dart';

// import Mongo.dart file
import 'Mongo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var db = await MongoDataBase.connect();

  runApp(MyApp(db: db));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.db});

  final db;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routes: {

        '/': (context) => MyHomePage(title: '🏠 Home Page', db: db),
        '/bonus': (context) => BonusPage(title:'Bonus Page'),
        '/login': (context) => LoginPage(db: db),
        '/register': (context) => RegisterPage(db: db),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

    );
  }
}

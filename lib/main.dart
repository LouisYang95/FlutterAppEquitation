import 'package:flutter/material.dart';
import 'package:flutter_app_equitation/Pages/bonus_page.dart';
import 'Pages/home_page.dart';

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
      routes: {BonusPage.tag : (context)=>const BonusPage(title: 'Bonus')},
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      // Write elements of db
      home: MyHomePage(title: '🏠 Home Page', db: db),
    );
  }
}





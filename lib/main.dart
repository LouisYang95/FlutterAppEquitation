import 'package:flutter/material.dart';
import 'package:flutter_app_equitation/Pages/bonus_page.dart';

import 'Pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routes: {BonusPage.tag : (context)=>const BonusPage(title: 'Bonus')},
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '🏠 Home Page'),
    );
  }
}



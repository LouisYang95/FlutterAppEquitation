import 'package:flutter/material.dart';
import '../Components/nav.dart';

import "../Components/log_manager.dart";




class MyHomePage extends StatefulWidget {
  // Const homepage with title and db
  MyHomePage({super.key, required this.title, this.db});

  final String title;
  final db;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        // Make me a logout button if user is logged and a login/register button if he's not
        actions: [
          LogManager(db: widget.db),
        ]

      ),
      drawer: DrawerWidget(db: widget.db),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Home Page',
            ),
          ],
        ),
      ),
    );
  }
}
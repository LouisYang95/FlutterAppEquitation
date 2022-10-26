import 'package:flutter/material.dart';
import '../Components/nav.dart';


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
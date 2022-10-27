import 'package:flutter/material.dart';

class MyEventPage extends StatefulWidget {
  static const String tag = "event";

  @override
  State<MyEventPage> createState() => _MyEventPageState();
}

class _MyEventPageState extends State<MyEventPage> {

  /* set possible values for dropDownButton */
  List<String> menuItems = ['Aperitif', 'Meals'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }

}

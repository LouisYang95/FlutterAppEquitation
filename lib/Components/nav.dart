import 'package:flutter/material.dart';
import 'package:flutter_app_equitation/Pages/bonus_page.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key, this.db});

  final db;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Navigation'),
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
          ),
          ListTile(
            title: Text('Bonus'),
            onTap: () {
              Navigator.pushNamed(context, '/bonus');
            },
          ),
        ],
      ),
    );
  }
}
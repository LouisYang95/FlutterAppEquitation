import 'package:flutter/material.dart';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key, this.db});

  final db;

  @override
  Widget build(BuildContext context) {
    // Get the user using SessionManager().get(id)

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
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            title: Text('Events'),
            onTap: () {
              Navigator.pushNamed(context, '/all_events');
            },
          ),
          ListTile(
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pushNamed(context, '/admin');
            },
          ),
        ],
      ),
    );
  }
}
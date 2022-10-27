import 'package:flutter/material.dart';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key, this.db});

  final db;

  @override
  Widget build(BuildContext context) {
    // Get the user using SessionManager().get(id)

    getUser() async {
      var id = await SessionManager().get('id');
      // Id to ObjectId
      var objectId = ObjectId.fromHexString(id);
      var user = await db.collection('users').findOne(where.eq('_id', objectId));
      return user;
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Text('Navigation'),
          ),
          ListTile(
          title: const Text('Bonus'),
          onTap: () {
            Navigator.pushNamed(context, '/bonus');
          },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/profil');
            },
          ),
          ListTile(
            title: const Text('Class'),
            onTap: () {
              Navigator.pushNamed(context, '/class');
            },
          ),
          ListTile(
            title: const Text('Contest'),
            onTap: () {
              Navigator.pushNamed(context, '/contest');
            },
          ),
          // Events
          ListTile(
            title: const Text('Events'),
            onTap: () {
              Navigator.pushNamed(context, '/all_events');
            },
          ),
          ListTile(
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pushNamed(context, '/admin');
            },
          ),
        ],
      ),
    );
  }
}

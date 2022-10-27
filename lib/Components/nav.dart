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

            // Print infos of user
          FutureBuilder(
            future: getUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data['is_admin'] == true) {
                  SessionManager().set('isAdmin', true);
                  // If user is admin, show the admin page
                  return Column(
                    // Add profile page + admin page
                    children: [
                      const Divider(
                        height: 20,
                        thickness: 5,
                        indent: 20,
                        endIndent: 20,
                      ),
                      ListTile(
                        title: const Text('Admin'),
                        onTap: () {
                          Navigator.pushNamed(context, '/admin');
                        },
                      ),
                    ],
                  );
                } else {
                  SessionManager().set('isAdmin', false);
                  return const Divider(
                    height: 20,
                    thickness: 5,
                    indent: 20,
                    endIndent: 20,
                  );
                }
              } else {
                return const Text('Loading...');
              }
            },
          ),
        ],
      ),
    );
  }
}

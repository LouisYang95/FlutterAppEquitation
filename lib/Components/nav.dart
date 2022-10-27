import 'package:flutter/material.dart';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key, this.db});

  final db;

  @override
  Widget build(BuildContext context) {
    // Get the user using SessionManager().get(id)
    var logo = "https://cdn.discordapp.com/attachments/930039778332786718/1035170994597396530/playstore.png";


    return Container(
      width: 200,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // const DrawerHeader(
            //   decoration: BoxDecoration(
            //     color: Colors.grey,
            //   ),
            //   child: Text('Navigation'),
            // ),
            const SizedBox(
              height: 60.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(248,105,58, 1.0)
                ),
              ),
            ),

            Image.network(logo),
            ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/');
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
            ListTile(
              title: const Text('Bonus', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/bonus');
              },
            ),
          ],
        ),
      ),
    );
  }
}

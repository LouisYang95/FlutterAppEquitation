import 'package:flutter/material.dart';

import 'package:flutter_app_equitation/Pages/bonus_page.dart';
import 'package:flutter_app_equitation/Pages/profile_page.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
            title: Text('Bonus'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BonusPage(
                            title: 'Bonus',
                          )));
            },
          ),
          ListTile(
            title: Text('Profil'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const UserProfil())));
            },
          ),
        ],
      ),
    );
  }
}

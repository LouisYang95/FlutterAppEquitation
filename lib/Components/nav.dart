import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key, this.db});

  final db;

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
            title: const Text('Bonus'),
            onTap: () {
              Navigator.pushNamed(context, '/bonus');
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
        ],
      ),
    );
  }
}

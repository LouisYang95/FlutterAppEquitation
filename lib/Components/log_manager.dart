import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class LogManager extends StatefulWidget {
  const LogManager({Key? key, this.db}) : super(key: key);

  final db;

  @override
  _LogManagerState createState() => _LogManagerState();
}

class _LogManagerState extends State<LogManager> {
  Future<bool> isLogged() async {
    var isLogged = await SessionManager().get('isLogged');
    if (isLogged == null || isLogged == true) {
      return true;
    } else {
      return false;
    }
  }

  // Use session.get('isLogged').then((value)
  // to check if user is logged or not
  // Use session.get('id').then((value)
  // to get the id of the user
  // Get the value of the session isLogged then stock it in a variable
  @override
  Widget build(BuildContext context) {
    var session = SessionManager();
    return FutureBuilder(
      future: isLogged(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true) {
            return IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                setState(() {
                  session.set('isLogged', false);
                  session.set('id', '');
                  print(session.set('id', ''));
                });
                Navigator.pushNamed(context, '/login');
              },
            );
          } else {
            return Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.login),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.app_registration),
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                ),
              ],
            );
          }
        } else {
          return const Text('Loading...');
        }
      },
    );
  }
}

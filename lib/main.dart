import 'package:flutter/material.dart';
import 'package:flutter_app_equitation/Pages/event_page.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

// Import all pages
import 'package:flutter_app_equitation/Pages/home_page.dart';
import 'package:flutter_app_equitation/Pages/login_page.dart';
import 'package:flutter_app_equitation/Pages/register_page.dart';
import 'package:flutter_app_equitation/Pages/bonus_page.dart';

import 'package:flutter_app_equitation/Pages/admin_page.dart';
import 'package:flutter_app_equitation/Pages/profile_page.dart';
import 'package:flutter_app_equitation/Pages/forgot_pass_page.dart';
import 'package:flutter_app_equitation/Pages/class_page.dart';
import 'package:flutter_app_equitation/Pages/contest_page.dart';
import 'package:flutter_app_equitation/Pages/all_events_page.dart';



// import Mongo.dart file
import 'Mongo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set state of SessionManager() to loggedIn (false) id empty and isAdmin to false
  var session = SessionManager();
  await session.set('isLogged', false);
  await session.set('id', '');
  await session.set('isAdmin', false);


  var db = await MongoDataBase.connect();
  runApp(MyApp(db: db));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.db});

  final db;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => MyHomePage(title: '🏠 Home Page', db: db),
        '/bonus': (context) => BonusPage(title: 'Bonus Page'),
        '/login': (context) => LoginPage(db: db),
        '/register': (context) => RegisterPage(db: db),
        '/contest': (context) => CreateContestPage(db: db),
        '/class': (context) => CreateClassPage(db: db),
        '/event': (context) => CreateEventPage(db: db),
        '/admin': (context) => AdminPage(db: db),
        '/forgot_password' : (context) => ForgotPasswordPage(db: db),
        '/all_events' : (context) => AllEventsPage(db: db),
        '/profil': (context) => UserProfil(db: db),
      },
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white.withAlpha(12000),
      ),
    );
  }
}

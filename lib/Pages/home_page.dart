import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Components/nav.dart';
// import "../Components/log_manager.dart";
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter_session_manager/flutter_session_manager.dart';

class MyHomePage extends StatefulWidget {
  // Const homepage with title and db
  MyHomePage({super.key, required this.title, this.db});

  final String title;
  final db;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  @override
  Widget build(BuildContext context) {

    List userDate = [];

    getAllUsers() async {
    // get users where creation_time exists in table users
      var users = await widget.db.collection('users').find(mongo.where.exists('creation_date')).toList();
      //only read users contains creation_date data

      var dayNow = DateTime.now().millisecondsSinceEpoch;

      print("dayNow");
      print(dayNow);

      //read create_date value of users
      for (var user in users) {

        var name = user['username'];

        var dayUser = user['creation_date'];
        print("dayUser");
        print(dayUser);

        var diff = dayNow - dayUser;
        print("diff $name");
        print(diff);

        //return user with diff <= 86400000
        if (diff <= 86400000) {
          print("user");
          print(user);
          //add user to userDate
          userDate.add(user);
        }
      }
      print("userDate : $userDate");
      return users;
    }

    // In the slider we want into the carousel slider widget one of the images and one of the user names
    // We want to do this for every user in the database
    // So we need to get all the users from the database
    // And then we need to map the users to the carousel slider widget
    // We need to do this in a future builder because we need to wait for the users to be fetched from the database
    // And we need to do this in a stateful widget because we need to rebuild the widget when the users are fetched

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        // actions: [
        //   LogManager(db: widget.db),
        // ]
      ),
      drawer: DrawerWidget(),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Nouveauté de la journée : ",
                style: TextStyle(fontSize: 20.0, decoration: TextDecoration.underline),
              ),
            ),
            FutureBuilder(
              future: getAllUsers(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return CarouselSlider(
                    options: CarouselOptions(
                      height: 390.0,
                      autoPlay: false,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: userDate.map<Widget>((user) {

                      if (user['creation_date'] != null) {

                        // var dayNow = DateTime.now().millisecondsSinceEpoch;
                        // var dayUser = snapshot.data[6]['creation_date'];
                        //
                        // print("Date Now : ${DateTime.now().millisecondsSinceEpoch}");
                        // print("Date User : ${snapshot.data[6]['creation_date']}");
                        //
                        // print(dayNow - dayUser);
                        //
                        // if (dayNow - dayUser <= 86400) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 30.0),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      Image.network(imgList[0]),
                                      Text(user['username'], style: const TextStyle(fontSize: 16.0, color: Colors.black)),
                                      Text(user['email'], style: const TextStyle(fontSize: 16.0, color: Colors.black)),
                                      Text(user['password'], style: const TextStyle(fontSize: 16.0, color: Colors.black)),
                                      Text(user['creation_date'].toString(), style: const TextStyle(fontSize: 16.0, color: Colors.black)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        // } else {
                        //   return Image.network(imgList[0]);
                        // }
                      }else {
                        return const Text("");
                      }
                    }).toList(),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

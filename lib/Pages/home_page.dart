import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Components/nav.dart';
import 'package:carousel_slider/carousel_slider.dart';
import "../Components/log_manager.dart";


class MyHomePage extends StatefulWidget {
  // Const homepage with title and db
  MyHomePage({super.key, required this.title, this.db});

  final String title;
  final db;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var logo = "https://cdn.discordapp.com/attachments/930039778332786718/1035170994597396530/playstore.png";

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
    List contestDate = [];
    List lessonDate = [];
    List partyDate = [];

    var dayNow = DateTime.now().millisecondsSinceEpoch;

    getAllUsers() async {
    // get users where creation_time exists in table users
      var users = await widget.db.collection('users').find(mongo.where.exists('creation_date')).toList();
      //read create_date value of users
      for (var user in users) {
        var dayUser = user['creation_date'];
        var diff = dayNow - dayUser;
        //return user with diff <= 86400000
        if (diff <= 86400000) {
          //add user to userDate
          userDate.add(user);
        }
      }
      return users;
    }

    getAllContests() async {
      // get users where creation_time exists in table users
      var contests = await widget.db.collection('contests').find(mongo.where.exists('creation_date')).toList();
      //read create_date value of users
      for (var contest in contests) {
        var dayContest = contest['creation_date'];
        var diff = dayNow - dayContest;
        //return user with diff <= 86400000
        if (diff <= 86400000) {
          //add user to userDate
          contestDate.add(contest);
        }
      }
      return contests;
    }

    getAllLessons() async {
      // get users where creation_time exists in table users
      var lessons = await widget.db.collection('lessons').find(mongo.where.exists('creation_date')).toList();
      //read create_date value of users
      for (var lesson in lessons) {
        var dayLesson = lesson['creation_date'];
        var diff = dayNow - dayLesson;
        //return user with diff <= 86400000
        if (diff <= 86400000) {
          //add user to userDate
          lessonDate.add(lesson);
        }
      }
      return lessons;
    }

    getAllParties() async {
      // get users where creation_time exists in table users
      var parties = await widget.db.collection('parties').find(mongo.where.exists('creation_date')).toList();
      //read create_date value of users
      for (var party in parties) {
        var dayParty = party['creation_date'];
        var diff = dayNow - dayParty;
        //return user with diff <= 86400000
        if (diff <= 86400000) {
          //add user to userDate
          partyDate.add(party);
        }
      }
      return parties;
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
        // Make me a logout button if user is logged and a login/register button if he's not
        actions: [
          LogManager(db: widget.db),
        ]
      ),
      drawer: DrawerWidget(),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Nouveauté de la journée : ",
                  style: TextStyle(fontSize: 25.0, decoration: TextDecoration.underline),
                ),
              ),

              //Users
              const Padding(
                padding: EdgeInsets.all(1.0),
                child: Text(
                  "Cavaliers : ",
                  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                ),
              ),
              FutureBuilder(
                future: getAllUsers(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return CarouselSlider(
                      options: CarouselOptions(
                        height: 310.0,
                        autoPlay: (userDate.length < 2 ? false : true),
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        viewportFraction: 0.6,
                      ),
                      items: userDate.map<Widget>((user) {

                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: 300,
                              height: 200,
                              margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 30.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    Image.network(imgList[0]),
                                    const SizedBox(height: 10.0),
                                    const Text("Nouveau Cavalier !", style: const TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10.0),
                                    Text(user['username'], style: const TextStyle(fontSize: 16.0, color: Colors.black, decoration: TextDecoration.underline)),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                      }).toList(),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),

              //Contests
              const Padding(
                padding: EdgeInsets.all(1.0),
                child: Text(
                  "Contests : ",
                  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                ),
              ),
              FutureBuilder(
                future: getAllContests(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return CarouselSlider(
                      options: CarouselOptions(
                        height: 310.0,
                        autoPlay: (contestDate.length < 2 ? false : true),
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        viewportFraction: 0.6,
                      ),
                      items: contestDate.map<Widget>((user) {

                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: 300,
                              height: 200,
                              margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 30.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    Image.network(imgList[1]),
                                    const SizedBox(height: 10.0),
                                    const Text("New Contest !", style: const TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10.0),
                                    Text(user['name'], style: const TextStyle(fontSize: 16.0, color: Colors.black, decoration: TextDecoration.underline)),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                      }).toList(),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),

              //Lessons
              const Padding(
                padding: EdgeInsets.all(1.0),
                child: Text(
                  "Lessons : ",
                  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                ),
              ),
              FutureBuilder(
                future: getAllLessons(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return CarouselSlider(
                      options: CarouselOptions(
                        height: 310.0,
                        autoPlay: (lessonDate.length < 2 ? false : true),
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        viewportFraction: 0.6,
                      ),
                      items: lessonDate.map<Widget>((user) {

                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: 300,
                              height: 200,
                              margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 30.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    Image.network(imgList[2]),
                                    const SizedBox(height: 10.0),
                                    const Text("New Lesson !", style: const TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10.0),
                                    Text(user['land'], style: const TextStyle(fontSize: 16.0, color: Colors.black, decoration: TextDecoration.underline)),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                      }).toList(),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),

              //Parties
              const Padding(
                padding: EdgeInsets.all(1.0),
                child: Text(
                  "Parties : ",
                  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                ),
              ),
              FutureBuilder(
                future: getAllParties(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return CarouselSlider(
                      options: CarouselOptions(
                        height: 310.0,
                        autoPlay: (partyDate.length < 2 ? false : true),
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        viewportFraction: 0.6,
                      ),
                      items: partyDate.map<Widget>((user) {

                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: 300,
                              height: 200,
                              margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 30.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    Image.network(imgList[3]),
                                    const SizedBox(height: 10.0),
                                    const Text("New Party !", style: const TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10.0),
                                    Text(user['theme'], style: const TextStyle(fontSize: 16.0, color: Colors.black, decoration: TextDecoration.underline)),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

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
      ),
    );
  }
}

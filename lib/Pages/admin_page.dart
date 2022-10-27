// Create an Admin Page composed of 4 elements, a list of users, a list of games, a list of societies and a list of lessons, a list of horses and a list of parties

import 'package:flutter/material.dart';



class AdminPage extends StatefulWidget {
  const AdminPage({super.key , this.db});

  final db;
  _MyAdminState createState() => _MyAdminState();
}

class _MyAdminState extends State<AdminPage> {
  // Get all users

  getAllUsers() async {
    var users = await widget.db.collection('users').find().toList();
    return users;
  }

  // Get all lessons

  getAllLessons() async {
    var lessons = await widget.db.collection('lessons').find().toList();
    return lessons;
  }

  // Get all parties

  getAllParties() async {
    var parties = await widget.db.collection('parties').find().toList();
    return parties;
  }


  // Get all horses

  getAllHorses() async {
    var horses = await widget.db.collection('horses').find().toList();
    return horses;
  }

  // Get all contests

  getAllContests() async {
    var contests = await widget.db.collection('contests').find().toList();
    return contests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Create a list of tabs
        child: DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Users'),
                  Tab(text: 'Lessons'),
                  Tab(text: 'Parties'),
                  Tab(text: 'Horses'),
                  Tab(text: 'Contests'),
                ],
              ),
              title: const Text('Admin Page'),
            ),
            body: TabBarView(
              children: [
                // Create a list of users
                FutureBuilder(
                  future: getAllUsers(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(snapshot.data[index]['username']),
                            subtitle: Text(snapshot.data[index]['email']),
                            // When we tap on a user we get all the infos about it in a dialog
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('User infos'),
                                    content: Text('Username: ${snapshot.data[index]['username']} \n Email: ${snapshot.data[index]['email']} \n Age : ${snapshot.data[index]['age']} \n admin: ${snapshot.data[index]['is_admin']}'),
                                    actions: [
                                      TextButton(
                                        child: Text('Close'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      // Text button to delete the user with a confirmation dialog
                                      TextButton(
                                        child: Text('Delete'),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Delete user'),
                                                content: Text('Are you sure you want to delete ${snapshot.data[index]['username']}?'),
                                                actions: [
                                                  TextButton(
                                                    child: Text('Close'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Delete'),
                                                    onPressed: () {
                                                      // Find the user in the db without using "where"
                                                      widget.db.collection('users').findOne({'_id': snapshot.data[index]['_id']}).then((value) {
                                                        // Delete the user
                                                        widget.db.collection('users').remove(value);

                                                        // Set state to refresh the list
                                                        setState(() {});
                                                        Navigator.of(context).pop();
                                                      });
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },

                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                // Create a list of lessons
                FutureBuilder(
                  future: getAllLessons(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(snapshot.data[index]['name']),
                            subtitle: Text(snapshot.data[index]['description']),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                // Create a list of parties
                FutureBuilder(
                  future: getAllParties(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(snapshot.data[index]['name']),
                            subtitle: Text(snapshot.data[index]['description']),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                // Create a list of horses
                FutureBuilder(
                  future: getAllHorses(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int
                        index) {
                          return ListTile(
                            title: Text(snapshot.data[index]['name']),
                            subtitle: Text(snapshot.data[index]['description']),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                // Create a list of contests
                FutureBuilder(
                  future: getAllContests(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(snapshot.data[index]['name']),
                            subtitle: Text(snapshot.data[index]['description']),
                          );
                        },
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
      ),
    );
  }
}


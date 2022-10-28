// Create an Admin Page composed of 4 elements, a list of users, a list of games, a list of societies and a list of lessons, a list of horses and a list of parties

import 'package:flutter/material.dart';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;



class AdminPage extends StatefulWidget {
  const AdminPage({super.key , this.db});

  final db;
  @override
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

  getAllOwners() async {
    var owners = await widget.db.collection('owners').find().toList();
    return owners;
  }
  
  deleteUserButton(snapshot) async {
    // If user logged in is not admin, don't display delete button
      if (await SessionManager().get('isAdmin') == true && await SessionManager().get('isLogged') == true && snapshot['is_admin'] == false) {
        return IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
             // Make a verification dialog
              showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete user'),
                      content: const Text('Are you sure you want to delete this user ?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            widget.db.collection('users').deleteOne(mongo.where.eq('_id', snapshot['_id']));
                            widget.db.collection('contests').deleteMany(mongo.where.eq('user', snapshot['_id']));
                            widget.db.collection('lessons').deleteMany(mongo.where.eq('user', snapshot['_id']));
                            widget.db.collection('parties').deleteMany(mongo.where.eq('user', snapshot['_id']));
                            widget.db.collection('lessons_participations').deleteMany(mongo.where.eq('user_id', snapshot['_id']));
                            widget.db.collection('parties_participations').deleteMany(mongo.where.eq('user_id', snapshot['_id']));
                            widget.db.collection('contests_participations').deleteMany(mongo.where.eq('user_id', snapshot['_id']));
                            widget.db.collection('horses').updateMany(mongo.where.eq('owner', snapshot['_id']), mongo.modify.set('owner', null).set('state', null).set('is_available', true));
                            widget.db.collection('horses').updateMany(mongo.where.eq('owners', snapshot['_id']), mongo.modify.pull('owners', snapshot['_id']).set('is_available', true));


                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            });
      } else {
        return Container();
      }
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
                                    title: const Text('User infos'),
                                    content: Text('Username: ${snapshot.data[index]['username']} \n Email: ${snapshot.data[index]['email']} \n Age : ${snapshot.data[index]['age']} \n admin: ${snapshot.data[index]['is_admin']}'),
                                    actions: [
                                      TextButton(
                                        child: const Text('Close'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      // Text button to delete the user with a confirmation dialog using the delete button function in form builder
                                      FutureBuilder(
                                        future: deleteUserButton(snapshot.data[index]),
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                          if (snapshot.hasData) {
                                            return snapshot.data;
                                          } else {
                                            return Container();
                                          }
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
                            title: Text(snapshot.data[index]['land'] + ' - ' + snapshot.data[index]['status']),
                            subtitle: Text("Date : ${snapshot.data[index]['date']}, Hour : ${snapshot.data[index]['when']}", style: TextStyle(color: Colors.grey)),
                            // If the user is admin, he can click on it to get more infos, but he has also the possibility to accept or reject the lesson if it's pending
                            onTap: () async {
                              if (await SessionManager().get('isAdmin') == true && await SessionManager().get('isLogged') == true) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    var user_id = snapshot.data[index]['user'];
                                    var user = widget.db.collection('users').findOne(mongo.where.eq('_id', user_id));
                                    return AlertDialog(
                                      title: const Text('Lesson infos'),
                                      content: Column(
                                        children: [
                                          Text('Land : ${snapshot.data[index]['land']} \n Date : ${snapshot.data[index]['date']} \n Hour : ${snapshot.data[index]['when']} \n Status : ${snapshot.data[index]['status']}'),
                                          FutureBuilder(
                                            future: user,
                                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                                              if (snapshot.hasData) {
                                                return Text('User : ${snapshot.data['username']}');
                                              } else {
                                                return const Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        // Put the close button on the same row as the accept and reject buttons
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              child: const Text('Close'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            // Accept button
                                            // If the lesson is pending, we can accept or reject it
                                            if (snapshot.data[index]['status'] == 'pending')
                                              TextButton(
                                                child: Text('Accept'),
                                                onPressed: () {
                                                  widget.db.collection('lessons').updateOne(mongo.where.eq('_id', snapshot.data[index]['_id']), mongo.modify.set('status', 'accepted'));
                                                  setState(() {});
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            // Reject button
                                            if (snapshot.data[index]['status'] == 'pending')
                                              TextButton(
                                                child: Text('Reject'),
                                                onPressed: () {
                                                  widget.db.collection('lessons').updateOne(mongo.where.eq('_id', snapshot.data[index]['_id']), mongo.modify.set('status', 'rejected'));
                                                  // Set state
                                                  setState(() {});
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
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
                // Create a list of parties
                FutureBuilder(
                  future: getAllParties(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      var _party = snapshot.data;
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(snapshot.data[index]['theme'] + ' - ' + snapshot.data[index]['status']),
                            subtitle: Text("Date : ${snapshot.data[index]['date']}, Hour : ${snapshot.data[index]['when']}", style: TextStyle(color: Colors.grey)),
                            // Same as the lessons, if the user is admin, he can click on it to get more infos, but he has also the possibility to accept or reject the party if it's pending
                            onTap: () async {
                              // Click on it to have more info (also comments from those who participat
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    var user_id = snapshot.data[index]['user'];
                                    var user = widget.db.collection('users').findOne(mongo.where.eq('_id', user_id));
                                    return AlertDialog(
                                      title: const Text('Party infos'),
                                      content: Column(
                                        children: [
                                          Text('Theme : ${snapshot.data[index]['theme']} \n Date : ${snapshot.data[index]['date']} \n Hour : ${snapshot.data[index]['when']} \n Status : ${snapshot.data[index]['status']}'),
                                          // For each element in whatToBring print the message and search for the user who wrote it
                                          if (snapshot.data[index]['whatToBring'] != null)
                                            // Text to say what users will bring "What to bring :"
                                            Text('What would users bring :'),
                                          if (snapshot.data[index]['whatToBring'] != null)
                                            for (var i = 0; i < snapshot.data[index]['whatToBring'].length; i++)
                                              FutureBuilder(
                                                future: widget.db.collection('users').findOne(mongo.where.eq('_id', snapshot.data[index]['whatToBring'][i]['user_id'])),
                                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                  if (snapshot.hasData) {
                                                    // Return the message and the username (subtitle)
                                                    return ListTile(
                                                      title: Text(snapshot.data['username']),
                                                      subtitle: Text(_party[index]['whatToBring'][i]['whatToBring']),
                                                    );
                                                  } else {
                                                    return const Center(
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  }
                                                },
                                              ),
                                          FutureBuilder(
                                            future: user,
                                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                                              if (snapshot.hasData) {
                                                return Text('Organization : ${snapshot.data['username']}');
                                              } else {
                                                return const Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              }
                                            },
                                          ),

                                        ],
                                      ),
                                      actions: [
                                        // Print a close button if the user is not admin in a futurebuilder
                                        FutureBuilder(
                                          future: SessionManager().get('isAdmin'),
                                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            if (snapshot.hasData) {
                                              if (snapshot.data == true) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    TextButton(
                                                      child: const Text('Close'),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    // Accept button
                                                    // If the party is pending, we can accept or reject it
                                                    if (_party[index]['status'] == 'pending' && snapshot.data == true)
                                                      TextButton(
                                                        child: Text('Accept'),
                                                        onPressed: () {
                                                          widget.db.collection('parties').updateOne(mongo.where.eq('_id', snapshot.data[index]['_id']), mongo.modify.set('status', 'accepted'));
                                                          setState(() {});
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    // Reject button
                                                    if (_party[index]['status'] == 'pending' && snapshot.data == true)
                                                      TextButton(
                                                        child: Text('Reject'),
                                                        onPressed: () {
                                                          widget.db.collection('parties').updateOne(mongo.where.eq('_id', snapshot.data[index]['_id']), mongo.modify.set('status', 'rejected'));
                                                          // Set state
                                                          setState(() {});
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                  ],
                                                );
                                              } else {
                                                return TextButton(
                                                  child: const Text('Close'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                );
                                              }
                                            } else {
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }
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
                            subtitle: Text("Age : ${snapshot.data[index]['age']}, Breed : ${snapshot.data[index]['breed']}", style: TextStyle(color: Colors.grey)),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Column(
                                      children: [
                                        Text(snapshot.data[index]['name']),
                                        // Make the second text a subtitle (police size smaller)
                                        Text("Age : ${snapshot.data[index]['age']}, Breed : ${snapshot.data[index]['breed']} \n Specialities : ${snapshot.data[index]['speciality'].join(' - ')}", style: TextStyle(color: Colors.grey, fontSize: 15)),
                                      ],
                                    ),
                                    content: Image.network(snapshot.data[index]['photo']),
                                    // Add all additional infos about the horse
                                    actions: [
                                      TextButton(
                                        child: Text('Close'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
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
                            subtitle: Text("Address : ${snapshot.data[index]['address']}, Date : ${snapshot.data[index]['date']}", style: TextStyle(color: Colors.grey)),
                            // When we click on it , like horses we got infos and image is print
onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Column(
                                      children: [
                                        Text(snapshot.data[index]['name']),
                                        // Make the second text a subtitle (police size smaller)
                                        Text("Address : ${snapshot.data[index]['address']} \n Date : ${snapshot.data[index]['date']}", style: TextStyle(color: Colors.grey, fontSize: 15)),
                                      ],
                                    ),
                                    content: Image.network(snapshot.data[index]['photo']),
                                    actions: [
                                      TextButton(
                                        child: Text('Close'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
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
                // Create a list of owners
              ],
            ),
          ),
        ),
      ),
    );
  }
}


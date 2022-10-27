// Create a page that will display parties, lessons and contests
import 'package:flutter/material.dart';

// import session manager
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class AllEventsPage extends StatefulWidget {
  const AllEventsPage({super.key, required this.db});

  final db;

  @override
  State<AllEventsPage> createState() => AllEventsPageState();
}

class AllEventsPageState extends State<AllEventsPage> {
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

  // Get all contests

  getAllContests() async {
    var contests = await widget.db.collection('contests').find().toList();
    return contests;
  }

  Future<void> saveParticipation(eventId,String type) async {
    var id = await SessionManager().get('id');
    var objectId = mongo.ObjectId.fromHexString(id);
    var user = await widget.db.collection('users').findOne(mongo.where.eq('_id', objectId));



    // If user, save participation, else redirect to login page
    if (user != null) {
      if (type == 'lesson') {
        // Check if lesson already exist in lesson_participations checking combo of user_id and lesson_id
        var lessonParticipation = await widget.db.collection('lessons_participations').findOne(mongo.where.eq('user_id', objectId).and(mongo.where.eq('lesson_id', eventId)));

        if (lessonParticipation == null) {
          widget.db.collection('lessons_participations').insertOne(
              <String, dynamic>{
                'user_id': user['_id'],
                'lesson_id': eventId,
                'adhesion_date': DateTime.now().toString().substring(0, 16)
              });
          var popup = showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text("Success", style: TextStyle(color: Colors.green)),
                  content: Text("You have successfully registered for this lesson"),
                );
              });
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
          return popup;
        } else {
          var popup = showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text("Error", style: TextStyle(color: Colors.red)),
                  content: Text("You are already registered to this lesson"),
                );
              });
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
          return popup;
        }




      }
      if (type == 'party') {
        // Check if party already exist in party_participations checking combo of user_id and party_id
        var partyParticipation = await widget.db.collection('parties_participations').findOne(mongo.where.eq('user_id', objectId).and(mongo.where.eq('party_id', eventId)));

        if (partyParticipation == null) {
          widget.db.collection('parties_participations').insertOne(
              <String, dynamic>{
                'user_id': user['_id'],
                'party_id': eventId,
                'adhesion_date': DateTime.now().toString().substring(0, 16)
              });
          var popup = showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text("Success", style: TextStyle(color: Colors.green)),
                  content: Text("You have successfully registered for this party"),
                );
              });
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
          return popup;
        } else {
          var popup = showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text("Error", style: TextStyle(color: Colors.red)),
                  content: Text("You are already registered to this party"),
                );
              });
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
          return popup;
        }
      }
      if (type == 'contest') {
        // Check if contest already exist in contest_participations checking combo of user_id and contest_id
        var contestParticipation = await widget.db.collection('contests_participations').findOne(mongo.where.eq('user_id', objectId).and(mongo.where.eq('contest_id', eventId)));

        if (contestParticipation == null) {
          widget.db.collection('contests_participations').insertOne(
              <String, dynamic>{
                'user_id': user['_id'],
                'contest_id': eventId,
                'adhesion_date': DateTime.now().toString().substring(0, 16)
              });
          var popup = showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text("Success", style: TextStyle(color: Colors.green)),
                  content: Text("You have successfully registered for this contest"),
                );
              });
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
          return popup;
        } else {
          var popup = showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text("Error", style: TextStyle(color: Colors.red)),
                  content: Text("You are already registered to this contest"),
                );
              });
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
          return popup;
        }
      }
    } else {
      Navigator.pushNamed(context, '/login');
    }

  }

    @override
    Widget build(BuildContext context) {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('All Events'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Lessons'),
                Tab(text: 'Parties'),
                Tab(text: 'Contests'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FutureBuilder(
                future: getAllLessons(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index)
                    {
                      return ListTile(
                        title: Text(snapshot.data[index]['land']),
                        subtitle: Text("Date : ${snapshot.data[index]['date']}, Hour : ${snapshot.data[index]['when']}", style: TextStyle(color: Colors.grey)),
                        trailing: ElevatedButton(
                          onPressed: () {
                              saveParticipation(snapshot.data[index]['_id'], 'lesson');
                          },
                          child: const Text('Participate'),
                        ),
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
              FutureBuilder(
                future: getAllParties(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(snapshot.data[index]['theme']),
                          subtitle: Text("Date : ${snapshot.data[index]['date']}, Hour : ${snapshot.data[index]['when']}", style: TextStyle(color: Colors.grey)),
                          trailing: ElevatedButton(
                            onPressed: () {
                              saveParticipation(snapshot.data[index]['_id'], 'party');
                            },
                            child: const Text('Participate'),
                          ),
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
              FutureBuilder(
                future: getAllContests(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(snapshot.data[index]['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data[index]['address']),
                              Text("Date : ${snapshot.data[index]['date']}", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              saveParticipation(snapshot.data[index]['_id'], 'contest');
                            },
                            child: const Text('Participate'),
                          ),
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
      );
    }
  }
       
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class HorsePage extends StatefulWidget {
  const HorsePage({Key? key, this.db}) : super(key: key);

  final db;

  @override
  HorsePageState createState() => HorsePageState();
}

class HorsePageState extends State<HorsePage> {
  getAllHorsesFree() async {
    var horses = await widget.db
        .collection('horses')
        .find(mongo.where.eq('is_available', true))
        .toList();
    return horses;
  }

  becomeFullOwner(horseId) async {
    var session = SessionManager();
    var userId = await session.get('id');
    if (userId != '') {
      var objectId = mongo.ObjectId.parse(userId);


      // Add the horse to the user's list of horses
      await widget.db.collection('users').update(
          mongo.where.id(objectId),
          mongo.modify
              .push('horses', [horseId, 'full']));


      // Set the horse as unavailable

      await widget.db.collection('horses').update(
          mongo.where.id(horseId),
          mongo.modify.set('is_available', false)
              .set('owner', objectId)
              .set('state', 'full'));

      // SetState
      setState(() {});
    } else {
      Navigator.pushNamed(context, '/login');
    }
  }


  checkIfPart(horseId) async {
    var horse = await widget.db.collection('horses').findOne(mongo.where.id(horseId));

    if (await horse['state'] == null || await horse['state'] != 'part') {
      return false;
    } else {
      return true;
    }
  }

becomePartOwner(horseId) async {
    var session = SessionManager();
    var userId = await session.get('id');
    if (userId != '') {
      var objectId = mongo.ObjectId.parse(userId);


      // Set the horse as unavailable if there are two owners, otherwise just add the owne and set the state to part
      // If there are two owners, set the horse as unavailable
      var horse = await widget.db.collection('horses').findOne(mongo.where.id(horseId));
      if (await horse['owners'] == null) {
        await widget.db.collection('users').update(
            mongo.where.id(objectId),
            mongo.modify
                .push('horses', [horseId, 'part']));

        await widget.db.collection('horses').update(
            mongo.where.id(horseId),
            mongo.modify.set('is_available', false)
                .set('owners', [objectId])
                .set('state', 'part'));
      } else {
        if (await horse['owners'].length == 1 &&
            await horse['owners'][0] == objectId) {
          var popup = showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text("Error", style: TextStyle(color: Colors.red)),
                  content: Text("You are already an owner of this horse"),
                );
              });
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
          return popup;
        }
        if (await horse['owners'].length == 2) {
          await widget.db.collection('horses').update(
              mongo.where.id(horseId),
              mongo.modify.set('is_available', false));
        } else if (await horse['owners'].length < 2) {
          await widget.db.collection('users').update(
              mongo.where.id(objectId),
              mongo.modify
                  .push('horses', [horseId, 'part']));

          await widget.db.collection('horses').update(
              mongo.where.id(horseId),
              mongo.modify.set('state', 'part')
                  .push('owners', objectId));
          }
        }

      // SetState
      setState(() {});
    } else {
      Navigator.pushNamed(context, '/login');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('🐴 BabacHorse '),
        ),
        body: Center(
          child: FutureBuilder(
              future: getAllHorsesFree(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: ((context, int index) {
                        return Center(
                          child: Card(
                              elevation: 4.0,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Container(
                                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                        child: Text(snapshot.data[index]['name'],
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30)
                                        ),
                                      ),
                                      subtitle: Row(
                                        children: [
                                          const SizedBox(height: 40.0),
                                          Text(snapshot.data[index]['genre']),
                                          const SizedBox(width: 20.0),
                                          Text('${snapshot.data[index]['age']} year'),
                                          const SizedBox(width: 20.0),
                                          Text(snapshot.data[index]['speciality'].join(' - ').toString()),
                                        ],
                                      ),
                                      trailing: Container(
                                        margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        child: Text(snapshot.data[index]['breed'],
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                                        ),
                                      ),
                                    ),
                                    Container(
                                        height: 200.0,
                                        child: Image.network(snapshot.data[index]['photo'], fit: BoxFit.cover)),
                                    Container(
                                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                        child: Text(
                                          snapshot.data[index]['description'],
                                          textAlign: TextAlign.center,
                                        )
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          FutureBuilder(
                                              future: checkIfPart(
                                                  snapshot.data[index]['_id']),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                if (snapshot.hasData) {
                                                  if (snapshot.data == false) {
                                                    return ElevatedButton(
                                                      onPressed: () {
                                                        becomePartOwner(
                                                            snapshot.data[index]['_id']);
                                                      },
                                                      child: const Text('Become Owner'),
                                                    );
                                                  } else {
                                                    return Text('Already part owned');
                                                  }
                                                } else {
                                                  return const CircularProgressIndicator();
                                                }
                                              }),
                                          ElevatedButton(
                                            onPressed: () {
                                              becomePartOwner(snapshot.data[index]['_id']);
                                            },
                                            child: const Text('Become Part Owner'),
                                          ),
                                        ])
                                  ],
                                ),
                              )),
                        );
                      }));
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ));
  }
}

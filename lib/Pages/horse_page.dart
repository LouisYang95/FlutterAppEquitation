import 'package:flutter/material.dart';
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

  getList(data) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Choose Horse'),
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
                          child: Column(children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child:
                                  Image.network(snapshot.data[index]['photo']),
                            ),
                            Text(snapshot.data[index]['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(snapshot.data[index]['genre'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                Text('${snapshot.data[index]['age']} year',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ],
                            ),
                            Container(
                                margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(snapshot.data[index]['breed']),
                                    Text(snapshot.data[index]['speciality']
                                        .toString()),
                                  ],
                                )),
                            Container(
                                margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                child: Text(
                                  snapshot.data[index]['description'],
                                  textAlign: TextAlign.center,
                                )),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: const Text('Become Owner'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: const Text('Become Half Boarder'),
                                  ),
                                ])
                          ]),
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

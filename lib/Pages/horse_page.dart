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
                                          Text(snapshot.data[index]['genre'],),
                                          const SizedBox(width: 20.0),
                                          Text('${snapshot.data[index]['age']} year'),
                                        ],
                                      ),
                                      trailing: Icon(Icons.favorite_outline),
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
                                          ElevatedButton(
                                            onPressed: () {},
                                            child: const Text('Become Owner'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {},
                                            child: const Text('Become Half Boarder'),
                                          ),
                                        ]
                                    )
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

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Components/nav.dart';

class HorsePage extends StatefulWidget {
  HorsePage({super.key, required this.db});

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
        drawer: DrawerWidget(db: widget.db),
        body: Center(
          child: FutureBuilder(
              future: getAllHorsesFree(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: ((context, int index) {
                        return Center(
                          child: Container(child: Column(
                            children: [
                              Center(
                                child: Image.network(
                                    snapshot.data[index]['photo']),
                              ),
                              Text(snapshot.data[index]['name']),
                              Row(
                                children: [
                                  Text(snapshot.data[index]['genre']),
                                  Text(snapshot.data[index]['age'].toString()),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(snapshot.data[index]['breed']),
                                  Text(snapshot.data[index]['speciality']
                                      .toString()),
                                ],
                              ),
                              Text(snapshot.data[index]['description'])
                            ],
                          ),
                        ));
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

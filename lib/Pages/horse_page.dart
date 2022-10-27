import 'dart:html';

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

  getList(data) {
    return List.generate(data.length, (index) {
      return Center(
        child: Column(
          children: [
            Text(data[index]['photo']),
            Text(data[index]['name']),
            Row(
              children: [
                Text(data[index]['genre']),
                Text(data[index]['age']),
              ],
            ),
            Row(
              children: [
                Text(data[index]['breed']),
                Text(data[index]['speciality']),
              ],
            ),
            Text(data[index]['description'])
            ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Choose Horse'),
        ),
        drawer: DrawerWidget(db: widget.db),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
                future: getAllHorsesFree(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
                      crossAxisCount: 3,
                      children: [getList(snapshot.data)],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ],
        )));
  }
}

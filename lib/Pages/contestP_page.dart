import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Components/nav.dart';

class ContestPage extends StatefulWidget {
  const ContestPage({super.key, required this.db});

  final db;

  @override
  State<ContestPage> createState() => ContestPageState();
}

class ContestPageState extends State<ContestPage> {
  final _formKey = GlobalKey<FormState>();

  String dropdownValue = 'Choose the riders contest';

  bool isValid = false;

  void updateContest() {
    //TODO implement update contest in DB
    Navigator.pushNamed(context, '/');
  }

  getAllContests() async {
    var contests = await widget.db.collection('contests').find().toList();
    return contests;
  }

  fillContestsList(data) {
    List<DropdownMenuItem<String>> horsemenItem = [];
    horsemenItem.add(const DropdownMenuItem(
      value: 'Choose the contest',
      child: Text('Choose the contest'),
    ));
    for (var i = 0; i < data.length; i++) {
      horsemenItem.add(DropdownMenuItem(
        value: data[i]['username'],
        child: Text(data[i]['username']),
      ));
    }
    return horsemenItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Participate Contest'),
        ),
        drawer: DrawerWidget(db: widget.db),
        body: Center(
            child: Column(children: [
          FutureBuilder(
              future: getAllContests(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return DropdownButtonFormField<String>(
                    dropdownColor: const Color.fromARGB(245, 215, 194, 239),
                    value: dropdownValue,
                    icon: const Icon(Icons.supervised_user_circle),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    validator: (String? value) {
                      if (value == 'Choose the contest') {
                        return "Type required";
                      }
                      return null;
                    },
                    items: fillContestsList(snapshot.data),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          Container(
              padding: const EdgeInsets.only(left: 150.0, top: 40.0),
              child: ElevatedButton(
                onPressed: isValid ? updateContest : null,
                child: const Text('Reserve'),
              ))
        ])));
  }
}

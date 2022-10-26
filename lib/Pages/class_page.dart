import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Components/nav.dart';
import '../Mongo.dart';

class Class {
  final String land;
  final String date;
  final String hour;
  final String duration;
  final String sport;

  Class(this.land, this.date, this.hour, this.duration, this.sport);
}

class CreateClassPage extends StatefulWidget {
  static const tag = "class_page";

  const CreateClassPage({super.key, this.db});

  final db;

  @override
  State<CreateClassPage> createState() => CreateClassPageState();
}

enum Land { career, carrousel }

class CreateClassPageState extends State<CreateClassPage> {
  final date = TextEditingController();
  final hour = TextEditingController();
  final duration = TextEditingController();
  final sport = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Land? _land = Land.career;

  List<String> menuItems = ['Training', 'Show Jumping', 'Endurance'];

  String? dropdownValue = 'Type of the Class';

  void createClass() {
    Class(_land.toString(), date.text, hour.text, duration.text, sport.text);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Class'),
      ),
      drawer: DrawerWidget(db: widget.db),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ListTile(
                title: const Text('Career'),
                leading: Radio(
                  value: Land.career,
                  groupValue: _land,
                  onChanged: (Land? value) {
                    setState(() {
                      _land = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Carrousel'),
                leading: Radio(
                  value: Land.carrousel,
                  groupValue: _land,
                  onChanged: (Land? value) {
                    setState(() {
                      _land = value;
                    });
                  },
                ),
              ),
              TextField(
                  controller: date,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Enter Date" //label text of field
                      ),
                  readOnly: true, // when true user cannot edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(), //get today's date
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      print(pickedDate);
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      setState(() {
                        date.text = formattedDate;
                      });
                    } else {
                      print("Date is not selected");
                    }
                  }),
              const Text('Hour'),
              TextField(
                  controller: hour,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.timer), labelText: "Enter the Time"),
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print(pickedTime.format(context));
                      DateTime parsedTime = DateFormat.jm()
                          .parse(pickedTime.format(context).toString());
                      print(parsedTime);
                      String formattedTime =
                          DateFormat('HH:mm:ss').format(parsedTime);
                      print(formattedTime);

                      setState(() {
                        hour.text = formattedTime;
                      });
                    } else {
                      print("Time is not selected");
                    }
                  }),
              const Text('Duration'),
              TextField(
                  controller: hour,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.timer), labelText: "Enter the Duration"),
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print(pickedTime.format(context));
                      DateTime parsedTime = DateFormat.jm()
                          .parse(pickedTime.format(context).toString());
                      print(parsedTime);
                      String formattedTime =
                          DateFormat('HH:mm:ss').format(parsedTime);
                      print(formattedTime);

                      setState(() {
                        hour.text = formattedTime;
                      });
                    } else {
                      print("Duration is not selected");
                    }
                  }),
              DropdownButton<String>(
                dropdownColor: const Color.fromARGB(245, 215, 194, 239),
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem(
                      value: 'Type of the Class',
                      child: Text('Type of the Class')),
                  DropdownMenuItem(value: 'Training', child: Text('Training')),
                  DropdownMenuItem(
                      value: 'Show_Jumping', child: Text('Show Jumping')),
                  DropdownMenuItem(
                      value: 'Endurance', child: Text('Endurance')),
                ],
              ),
              Container(
                  padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                  child: ElevatedButton(
                    onPressed: createClass,
                    child: const Text('Reserve'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

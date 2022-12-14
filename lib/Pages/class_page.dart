import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:flutter_session_manager/flutter_session_manager.dart';

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

  const CreateClassPage({Key? key, this.db}) : super(key: key);

  final db;

  @override
  State<CreateClassPage> createState() => CreateClassPageState();
}

enum Land { career, carrousel }

enum DurationT { half, hour }

class CreateClassPageState extends State<CreateClassPage> {
  String land = 'Career';
  final date = TextEditingController();
  final hour = TextEditingController();
  String duration = '30 min';

  final _formKey = GlobalKey<FormState>();

  /* Set default value for radio input */
  Land? _land = Land.career;
  DurationT? _duration = DurationT.half;

  /* set possible values for dropDownButton */
  List<String> menuItems = ['Training', 'Show Jumping', 'Endurance'];

/* set default value for the dropDownButton */
  String dropdownValue = 'Type of the Class';

/* Display button if data in the inputs is correct */
  bool isValid = false;

  // Let user_id be the id of the user who created the class
  getUserId() async {
    var user_id = await SessionManager().get("id");
    // Transform it to objectId and search it in the database
    var objectId = mongo.ObjectId.fromHexString(user_id);
    var user = await widget.db.collection('users').findOne({"_id": objectId});
    return user['_id'];


  }




  Future<void> createClass() async {
    var user_id = await SessionManager().get("id");
    if (user_id != "") {
      String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
      var c = Class(land, date.text, hour.text, duration, dropdownValue);
      widget.db.collection('lessons').insertOne(<String, dynamic>{
        'land': c.land,
        'date': c.date,
        'when': c.hour,
        'duration': c.duration,
        'type': c.sport,
        'status': "pending",
        'user': await getUserId(),
        'creation_date': DateTime.now().millisecondsSinceEpoch,
        'creation_real_date': formattedDate
      });
      Navigator.pushNamed(context, '/');
    }else {
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('???? BabacHorse '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                color: Color.fromRGBO(248,105,58, 1),
                child: const Text("New Lesson", style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 36)),
              ),
              Form(
                key: _formKey,
                onChanged: () {
                  setState(() {
                    isValid = _formKey.currentState!.validate();
                  });
                },
                child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 80.0, top: 40.0, bottom: 10.0),
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
                                    land = 'Career';
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
                                    land = 'Carrousel';
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                          controller: date,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.calendar_today),
                              labelText: "Enter Date"),
                          readOnly: true,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Date required";
                            }
                            return null;
                          },
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101));

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);
                              setState(() {
                                date.text = formattedDate;
                              });
                            }
                          }),

                      const SizedBox(height: 20.0),

                      TextFormField(
                          controller: hour,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.timer), labelText: "Enter the Time"),
                          readOnly: true,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Time required";
                            }
                            return null;
                          },
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );

                            if (pickedTime != null) {
                              DateTime parsedTime = DateFormat.jm()
                                  .parse(pickedTime.format(context).toString());

                              String formattedTime =
                                  DateFormat('HH:mm').format(parsedTime);

                              setState(() {
                                hour.text = formattedTime;
                              });
                            }
                          }),
                      Container(
                        padding: const EdgeInsets.only(left: 80.0, top: 20.0, bottom: 10.0),
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text('30 min'),
                              leading: Radio(
                                value: DurationT.half,
                                groupValue: _duration,
                                onChanged: (DurationT? value) {
                                  setState(() {
                                    _duration = value;
                                    duration = '30 min';
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('1 hour'),
                              leading: Radio(
                                value: DurationT.hour,
                                groupValue: _duration,
                                onChanged: (DurationT? value) {
                                  setState(() {
                                    _duration = value;
                                    duration = '1 hour';
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      DropdownButtonFormField<String>(
                        dropdownColor: const Color.fromARGB(245, 215, 194, 239),
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        validator: (String? value) {
                          if (value == 'Type of the Class') {
                            return "Type required";
                          }
                          return null;
                        },
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
                          padding: const EdgeInsets.only(left: 0.0, top: 40.0),
                          child: ElevatedButton(
                            onPressed: isValid ? createClass : null,
                            child: const Text('Reserve'),
                          )),
                    ],
                  ),
                ),
            ],
          ),
          ),
      ),
    );
  }
}

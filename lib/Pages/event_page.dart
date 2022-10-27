import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Components/nav.dart';

class Event {
  final String theme;
  final String date;
  final String hour;
  final String desc;

  Event(this.theme, this.date, this.hour, this.desc);
}

class CreateEventPage extends StatefulWidget {
  static const tag = "event_page";

    const CreateEventPage({Key? key, this.db}) : super(key: key);

  final db;

  @override
  State<CreateEventPage> createState() => CreateEventPageState();
}

enum Theme { aperitif, meals }

class CreateEventPageState extends State<CreateEventPage> {
  String theme = 'Aperitif';
  final date = TextEditingController();
  final desc = TextEditingController();
  final hour = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  /* Set default value for radio input */
  Theme? _theme = Theme.aperitif;

/* Display button if data in the inputs is correct */
  bool isValid = false;

  void createClass() {
    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    var c = Event(theme, date.text, hour.text, desc.text);
    widget.db.collection('parties').insertOne(<String, dynamic>{
      'theme': c.theme,
      'date': c.date,
      'when': c.hour,
      'description': c.desc,
      'pending': true,
      'creation_date': DateTime.now().millisecondsSinceEpoch,
      'creation_real_date': formattedDate
    });
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      drawer: DrawerWidget(db: widget.db),
      body: Center(
        child: Form(
          key: _formKey,
          onChanged: () {
            setState(() {
              isValid = _formKey.currentState!.validate();
            });
          },
          child: Column(
            children: [
              ListTile(
                title: const Text('aperitif'),
                leading: Radio(
                  value: Theme.aperitif,
                  groupValue: _theme,
                  onChanged: (Theme? value) {
                    setState(() {
                      _theme = value;
                      theme = 'aperitif';
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('meals'),
                leading: Radio(
                  value: Theme.meals,
                  groupValue: _theme,
                  onChanged: (Theme? value) {
                    setState(() {
                      _theme = value;
                      theme = 'meals';
                    });
                  },
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
              TextFormField(
                controller: desc,
                maxLines: 8,
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), labelText: "Description"),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Description required";
                  }
                  return null;
                },
              ),
              const Text('Hour'),
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
                  padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                  child: ElevatedButton(
                    onPressed: isValid ? createClass : null,
                    child: const Text('Reserve'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

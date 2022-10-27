import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Components/nav.dart';

class Contest {
  final String name;
  final String address;
  final String picture;
  final String date;

  Contest(this.name, this.address, this.picture, this.date);
}

class CreateContestPage extends StatefulWidget {
  const CreateContestPage({super.key, required this.db});

  final db;

  @override
  State<CreateContestPage> createState() => CreateContestPageState();
}

class CreateContestPageState extends State<CreateContestPage> {
  /* controllers here */
  final name = TextEditingController();
  final address = TextEditingController();
  final picture = TextEditingController();
  final date = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  /* set default value for the dropDownButton */
  String dropdownValue = 'Choose the riders who participate in the contest';

/* Display button if data in the inputs is correct */
  bool isValid = false;

  void createContest() {
    var c = Contest(name.text, address.text, picture.text, date.text);
    widget.db.collection('contests').insertOne(<String, dynamic>{
      'name': c.name,
      'address': c.address,
      'picture': c.picture,
      'date': c.date,
      'creation_date': DateTime.now().toString().substring(0, 16),
    });
    Navigator.pushNamed(context, '/');
  }

  getAllUsers() async {
    var users = await widget.db.collection('users').find().toList();
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Contest'),
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
              TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.star_outlined),
                      labelText: "Enter the name"),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Name required";
                    }
                    return null;
                  }),
              TextFormField(
                  controller: address,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.location_on),
                      labelText: "Enter the address of the contest"),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "address required";
                    }
                    return null;
                  }),
              TextFormField(
                  controller: picture,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.picture_in_picture),
                      labelText: "Enter the link of the picture"),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Link required";
                    }
                    return null;
                  }),
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
              Container(
                  padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                  child: ElevatedButton(
                    onPressed: isValid ? createContest : null,
                    child: const Text('Create'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

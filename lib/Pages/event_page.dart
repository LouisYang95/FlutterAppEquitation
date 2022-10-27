import 'package:flutter/material.dart';

class MyEventPage extends StatefulWidget {
  static const String tag = "event";

  @override
  State<MyEventPage> createState() => _MyEventPageState();
}

class _MyEventPageState extends State<MyEventPage> {

  /* set possible values for dropDownButton */
  List<String> menuItems = ['Aperitif', 'Meals'];

  /* set default value for the dropDownButton */
  String dropdownValue = 'Theme night';

  /* Display button if data in the inputs is correct */
  bool isValid = false;

  final _formKey = GlobalKey<FormState>();

  void createClass() {
    var c = Class(dropdownValue);
    widget.db.collection('parties').insertOne(<String, dynamic>{
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme night'),
      ),
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
            DropdownButtonFormField<String>(
              dropdownColor: const Color.fromARGB(245, 215, 194, 239),
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              validator: (String? value) {
                if (value == 'Theme night') {
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
                    value: 'Theme nights',
                    child: Text('Theme night')),
                DropdownMenuItem(value: 'Aperitif', child: Text('Aperitif')),
                DropdownMenuItem(
                    value: 'Meals', child: Text('Meals')),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}

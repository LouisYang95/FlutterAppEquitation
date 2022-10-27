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
  String dropdownValue = 'Type of the Class';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event'),
      ),
      body: Center(
        child: Column(
          children: [
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
                DropdownMenuItem(value: 'Aperitif', child: Text('Aperitif')),
                DropdownMenuItem(
                    value: 'Meals', child: Text('Meals')),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

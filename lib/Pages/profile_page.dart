import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_app_equitation/classses/class_users.dart';

class UserProfil extends StatefulWidget {
  static const tag = "user_profil";
  const UserProfil({super.key, this.db});

  final db;
  @override
  State<UserProfil> createState() => _UserProfilState();
}

class _UserProfilState extends State<UserProfil> {
  final _formKey = GlobalKey<FormState>();
  final _nameField = TextEditingController();
  final _emailField = TextEditingController();
  final _ffeField = TextEditingController();

  Uri youtubeUrl = Uri.parse('https://www.youtube.com/');
  var _name = 'Nom';
  bool showInfo = false;
  bool isCompleted = false;
  List myProfil = [];

  @override
  void initState() {
    super.initState();
    getUser();
    if (_ffeField.text.isNotEmpty) {
      setState(() {
        isCompleted = true;
      });
    }
  }

  defineNewValue(var variable, final controller) {
    if (variable == _name) {
      setState(() {
        _name = controller.text;
        Navigator.pop(context);
      });
    } else if (variable == _emailField) {
      setState(() {
        _emailField.text = controller.text;
        Navigator.pop(context);
      });
    }
  }

  changeName(var variable, final controller) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: SizedBox(
            height: 150,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 237, 141, 68)),
                      ),
                      labelText: 'change it',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print(variable);
                      defineNewValue(variable, controller);
                    },
                    child: const Text('change'),
                  )
                ]),
          ));
        });
  }

  getUser() async {
    var user = await widget.db
        .collection("users")
        .findOne(mongo.where.eq('username', 'user2'));
    print(user);
    Users me = Users(
      name: user['username'],
      email: user['email'],
      password: user['password'],
    );
    setState(() {
      myProfil.add(me);
      defineControllerUser();
    });
  }

  defineControllerUser() {
    _nameField.text = myProfil[0].name;
    _emailField.text = myProfil[0].email;
    _name = myProfil[0].name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
          ),
          GestureDetector(
            onTap: () async {
              changeName(_name, _nameField);
              getUser();
            },
            child: ListTile(
              title: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  Text(_name),
                  const Icon(Icons.edit),
                ],
              )),
            ),
          ),
          Form(
              key: _formKey,
              child: Center(
                  child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 300,
                    child: Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10),
                        // child: TextFormField(
                        //   // onTap: defineNewValue(_emailField, _emailField),
                        //   enabled: false,
                        //   controller: _emailField,
                        //   decoration: const InputDecoration(
                        //     border: OutlineInputBorder(
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(20)),
                        //     ),
                        //     labelText: 'Email',
                        //   ),
                        // ),
                        child: GestureDetector(
                          onTap: () async {
                            changeName(_emailField, _emailField);
                            getUser();
                          },
                          child: ListTile(
                            title: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 10),
                                Text(_emailField.text),
                                const Icon(Icons.edit),
                              ],
                            )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            print('ok');
                          },
                          child: TextFormField(
                            enabled: false,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              labelText: 'Password',
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  !showInfo
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              showInfo = !showInfo;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.info, color: Colors.orange),
                              Text('show info'),
                              Icon(Icons.arrow_downward),
                            ],
                          ))
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              showInfo = !showInfo;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.info, color: Colors.orange),
                              Text('hide info'),
                              Icon(Icons.arrow_upward),
                            ],
                          )),
                  showInfo
                      ? SizedBox(
                          width: 300,
                          child: Column(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                enabled: false,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  labelText: 'ages',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  labelText: 'Phone Number',
                                ),
                              ),
                            ),
                            !isCompleted
                                ? Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: GestureDetector(
                                      onTap: () {
                                        print('ok');
                                      },
                                      child: TextFormField(
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          labelText: 'LINK TO YOUR FFE',
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: GestureDetector(
                                      onTap: () {
                                        launchUrl(youtubeUrl);
                                      },
                                      child: Text('This is your FFE profil'),
                                    ))
                          ]),
                        )
                      : Container(),
                ],
              )))
        ]));
  }
}

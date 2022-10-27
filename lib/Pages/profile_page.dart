import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import 'package:flutter_app_equitation/classses/class_users.dart';
import '../main.dart';

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
  final _passwordField = TextEditingController();
  final _ffeField = TextEditingController();
  var session = SessionManager();

  Uri youtubeUrl = Uri.parse('https://www.youtube.com/');
  // var _name = 'Nom';
  bool showInfo = false;
  bool isCompleted = false;
  List myProfil = [];
  bool isConnected = false;

  Future<bool> isLogged() async {
    var isLogged = await SessionManager().get('isLogged');
    var id = await SessionManager().get('id');

    if (isLogged == null || isLogged == true) {
      isConnected = true;
    } else {
      isConnected = false;
    }
    return isConnected;
  }

  @override
  void initState() {
    super.initState();
    isLogged();
    getUser();
    if (_ffeField.text.isNotEmpty) {
      setState(() {
        isCompleted = true;
      });
    }
  }

  defineNewValue(var variable, final controller) async {
    var idUser = await SessionManager().get('id');
    var id = mongo.ObjectId.fromHexString(idUser);
    if (variable == _nameField) {
      setState(() {
        _nameField.text = controller.text;
        Navigator.pop(context);
      });
    } else if (variable == _emailField) {
      setState(() {
        _emailField.text = controller.text;
        Navigator.pop(context);
      });
    } else if (variable == _passwordField) {
      setState(() {
        _passwordField.text = controller.text;
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
                  (variable != _passwordField)
                      ? TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 237, 141, 68)),
                            ),
                            labelText: 'change it',
                          ),
                        )
                      : TextField(
                          obscureText: true,
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
                      defineNewValue(variable, controller);
                    },
                    child: const Text('change'),
                  )
                ]),
          ));
        });
  }

  void getUser() async {
    var idUser = await SessionManager().get('id');
    var id = mongo.ObjectId.fromHexString(idUser);
    var user =
        await widget.db.collection('users').findOne(mongo.where.eq('_id', id));
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

  void defineControllerUser() {
    _nameField.text = myProfil[0].name;
    _emailField.text = myProfil[0].email;
    _passwordField.text = myProfil[0].password;
  }

  void updateToDatabase() async {
    // update users info to mongodb
    var idUser = await SessionManager().get('id');
    var id = mongo.ObjectId.fromHexString(idUser);
    var update = await widget.db.collection('users').update(
        mongo.where.eq('_id', id),
        mongo.modify
            .set('username', _nameField.text)
            .set('email', _emailField.text)
            .set('password', _passwordField.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: isConnected
          ? Column(
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
                      changeName(_nameField, _nameField);
                    },
                    child: ListTile(
                      title: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 10),
                          Text(_nameField.text),
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
                                child: GestureDetector(
                                  onTap: () async {
                                    changeName(_emailField, _emailField);
                                    getUser();
                                  },
                                  child: ListTile(
                                    title: Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(width: 10),
                                        const Text('Mail : '),
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
                                  onTap: () async {
                                    changeName(_passwordField, _passwordField);
                                    getUser();
                                  },
                                  child: ListTile(
                                    title: Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        SizedBox(width: 10),
                                        Text('Password : '),
                                        Text('********'),
                                        Icon(Icons.edit),
                                      ],
                                    )),
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          labelText: 'Phone Number',
                                        ),
                                      ),
                                    ),
                                    isCompleted
                                        ? Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: GestureDetector(
                                              onTap: () {

                                              },
                                              child: TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
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
                                              child: Text(
                                                  'This is your FFE profil'),
                                            ))
                                  ]),
                                )
                              : Container(),
                        ],
                      )))
                ])
          : Center(
            child: Column(
                //on click go back to main page
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You are not connected'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: const Text('Go back to main page'),
                  ),
                ],
              ),
          ),
    );
  }
}

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
  var session = SessionManager();

  // My variable for controller textfield :
  final _nameField = TextEditingController();
  final _emailField = TextEditingController();
  final _passwordField = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _agesField = TextEditingController();
  final _ffeField = TextEditingController();
  final _photoUrl = TextEditingController();

  // Uri ffeUrl = Uri.parse('https://www.ffe.com/');
  bool showInfo = false;
  bool isCompleted = false;
  List myProfil = [];
  bool isConnected = false;

  Future<bool> isLogged() async {
    var isLogged = await SessionManager().get('isLogged');
    if (isLogged == true) {
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
  }

  defineNewValue(var variable, final controller) async {
    var idUser = await SessionManager().get('id');
    var id = mongo.ObjectId.fromHexString(idUser);
    if (controller.text == null || controller.text == '') {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Warning'),
                content: Text('Complete the field please'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'),
                  )
                ],
              ));
    }
    if (variable == _nameField) {
      setState(() {
        _nameField.text = controller.text;
        widget.db.collection('users').update(mongo.where.eq('_id', id),
            mongo.modify.set('username', _nameField.text));
        Navigator.pop(context);
      });
    } else if (variable == _emailField) {
      setState(() {
        widget.db.collection('users').update(mongo.where.eq('_id', id),
            mongo.modify.set('email', _emailField.text));
        _emailField.text = controller.text;
        Navigator.pop(context);
      });
    } else if (variable == _passwordField) {
      setState(() {
        widget.db.collection('users').update(mongo.where.eq('_id', id),
            mongo.modify.set('password', _passwordField.text));
        _passwordField.text = controller.text;
        Navigator.pop(context);
      });
    } else if (variable == _photoUrl) {
      setState(() {
        widget.db.collection('users').update(mongo.where.eq('_id', id),
            mongo.modify.set('photoUrl', _photoUrl.text));
        _photoUrl.text = controller.text;
        Navigator.pop(context);
      });
    }
  }

  addUserData() async {
    var idUser = await SessionManager().get('id');
    var id = mongo.ObjectId.fromHexString(idUser);
    if (_phoneNumber.text != '' &&
        _agesField.text != '' &&
        _ffeField.text != '') {
      setState(() {
        _phoneNumber.text = _phoneNumber.text;
        _agesField.text = _agesField.text;
        _ffeField.text = _ffeField.text;
        if (_agesField.text.length > 2) {
          _agesField.text = _agesField.text.substring(0, 2);
        }
        if (_phoneNumber.text.length > 10) {
          _phoneNumber.text = _phoneNumber.text.substring(0, 10);
        }

        if (_phoneNumber.text.contains(RegExp(r'[a-zA-Z]')) ||
            _agesField.text.contains(RegExp(r'[a-zA-Z]'))) {
          _phoneNumber.text =
              _phoneNumber.text.replaceAll(RegExp(r'[a-zA-Z]'), '');
          _agesField.text = _agesField.text.replaceAll(RegExp(r'[a-zA-Z]'), '');
        }
        widget.db.collection('users').update(mongo.where.eq('_id', id),
            mongo.modify.set('phoneNumber', _phoneNumber.text));
        widget.db.collection('users').update(mongo.where.eq('_id', id),
            mongo.modify.set('ages', _agesField.text));
        widget.db.collection('users').update(
            mongo.where.eq('_id', id), mongo.modify.set('ffe', _ffeField.text));
        Navigator.of(context).pop();
      });
    } else {
      //show alert if one of the field is empty
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Warning'),
                content: Text('Complete the field please'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'),
                  )
                ],
              ));
    }
  }

  changeValue(var variable, final controller) {
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
                      Navigator.of(context).pop();
                    },
                    child: const Text('change'),
                  )
                ]),
          ));
        });
  }

  void getUser() async {
    var idUser = await SessionManager().get('id');
    if (idUser != '' && idUser != null) {
      var id = mongo.ObjectId.fromHexString(idUser);
      var user = await widget.db
          .collection('users')
          .findOne(mongo.where.eq('_id', id));
      Users me = Users(
        name: user['username'],
        email: user['email'],
        password: user['password'],
        phone: user['phoneNumber'],
        ages: user['ages'],
        ffe: user['ffe'],
        photoUrl: user['photo'],
      );
      setState(() {
        myProfil.add(me);
        defineControllerUser();
      });
    }
  }

  void defineControllerUser() {
    _nameField.text = myProfil[0].name;
    _emailField.text = myProfil[0].email;
    _passwordField.text = myProfil[0].password;
    _agesField.text = myProfil[0].ages;
    _phoneNumber.text = myProfil[0].phone;
    _ffeField.text = myProfil[0].ffe;
    _photoUrl.text = myProfil[0].photoUrl;
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
          ? SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  Container(
                      child: GestureDetector(
                    onTap: () {
                      changeValue(_photoUrl, _photoUrl);
                    },
                    child: _photoUrl != null
                        ? CircleAvatar(
                            radius: 90,
                            backgroundImage: NetworkImage(_photoUrl.text),
                          )
                        : const Icon(Icons.person),
                  )),
                  GestureDetector(
                    onTap: () async {
                      changeValue(_nameField, _nameField);
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
                                    changeValue(_emailField, _emailField);
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
                                    changeValue(_passwordField, _passwordField);
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
                                      if (myProfil[0].ffe != null &&
                                          myProfil[0].ffe != '') {
                                        setState(() {
                                          isCompleted = true;
                                        });
                                      }
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
                                  height: 300,
                                  child: Column(children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: TextFormField(
                                        controller: _agesField,
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
                                        controller: _phoneNumber,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          labelText: 'Phone Number',
                                        ),
                                      ),
                                    ),
                                    !isCompleted
                                        ? Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: TextFormField(
                                                onChanged: (value) =>
                                                    _ffeField.text = value,
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
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    launchUrl(Uri.parse(
                                                        _ffeField.text));
                                                  },
                                                  child: const Text(
                                                      'This is your FFE profil'),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    changeValue(
                                                        _ffeField, _ffeField);
                                                  },
                                                  child: const Icon(Icons.edit),
                                                )
                                              ],
                                            )),
                                    ElevatedButton(
                                      onPressed: () {
                                        addUserData();
                                      },
                                      child: const Text('Complete your profil'),
                                    ),
                                  ]),
                                )
                              : Container(),
                        ],
                      )))
                ]))
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

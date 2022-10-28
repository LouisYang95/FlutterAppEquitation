import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import 'package:flutter_app_equitation/classes/class_users.dart';
import 'package:flutter_app_equitation/classes/class_horse.dart';

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

  //form horses
  final _nameHorseField = TextEditingController();
  final _ageHorseField = TextEditingController();
  final _breedHorseField = TextEditingController();

  // Uri ffeUrl = Uri.parse('https://www.ffe.com/');
  bool isCompleted = false;
  List myProfil = [];
  bool isConnected = false;
  var _selectedLeague = 'Select your league';
  List myHorses = [];

  //function to get session manager to check if we are logged
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
    getHorsesData();
  }

//function to update our data
  defineNewValue(var variable, final controller) async {
    var idUser = await SessionManager().get('id'); //get id
    var id = mongo.ObjectId.fromHexString(idUser); //change id
    if (controller.text == null || controller.text == '') {
      //show our dialog box if it's null or empty
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

    //part where we update every data for our user
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

//function to every add/ update info from our form
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

// function to show our profil info
  showInfo() {
    if (myProfil[0].ffe != null && myProfil[0].ffe != '') {
      setState(() {
        isCompleted = true;
      });
    }
    // show dialog box form for further info
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Others Informations'),
            actions: [
              SizedBox(
                width: 300,
                child: Column(children: <Widget>[
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _agesField,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
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
                          borderRadius: BorderRadius.all(Radius.circular(20)),
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
                              onChanged: (value) => _ffeField.text = value,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
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
                                  launchUrl(Uri.parse(_ffeField.text));
                                },
                                child: const Text('This is your FFE profil'),
                              ),
                              GestureDetector(
                                onTap: () {
                                  changeValue(_ffeField, _ffeField);
                                },
                                child: const Icon(Icons.edit),
                              )
                            ],
                          )),
                  const SizedBox(height: 40.0),
                  ElevatedButton(
                    onPressed: () {
                      addUserData();
                    },
                    child: const Text('Complete your profil'),
                  ),
                ]),
              )
            ],
          );
        });
  }

//function to get every horses
  getHorsesData() async {
    var idUser = await SessionManager().get('id');
    var id = mongo.ObjectId.fromHexString(idUser);
    var horses =
        await widget.db.collection('horses').find(mongo.where.eq('owner', id));
    print('this function');
    horses.forEach((element) {
      print(element);
      setState(() {
        myHorses.add(element);
        print(myHorses);
      });
    });
  }

  defineValueHorse() {
    _nameHorseField.text = myHorses[0]['name'];
    _breedHorseField.text = myHorses[0]['breed'];
    _ageHorseField.text = myHorses[0]['age'].toString();
  }

  editHorseInDatabase() async {
    var idUser = await SessionManager().get('id');
    var id = mongo.ObjectId.fromHexString(idUser);
    widget.db.collection('horses').update(mongo.where.eq('owner', id),
        mongo.modify.set('name', _nameHorseField.text));
    widget.db.collection('horses').update(mongo.where.eq('owner', id),
        mongo.modify.set('breed', _breedHorseField.text));
    widget.db.collection('horses').update(mongo.where.eq('owner', id),
        mongo.modify.set('age', int.parse(_ageHorseField.text)));
    Navigator.of(context).pop();
  }

  getHorses() async {
    defineValueHorse();
    showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
              child: AlertDialog(
                  content: Column(
            children: [
              ...myHorses.map((e) => ListTile(
                  title: Card(
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Column(children: [
                        TextField(
                          controller: _nameHorseField,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            labelText: 'Name',
                          ),
                        ),
                        TextField(
                          controller: _breedHorseField,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            labelText: 'Breed',
                          ),
                        ),
                        TextField(
                          controller: _ageHorseField,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            labelText: 'Age',
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              editHorseInDatabase();
                            },
                            child: const Text('Edit'))
                      ]))))
            ],
          )));
        });
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
        league: user['league'],
        horses: user['horses'],
      );
      setState(() {
        myProfil.add(me);
        defineControllerUser();
      });
    }
  }

//function to define league into our database
  void defineUserLeague() async {
    var idUser = await SessionManager().get('id');
    var id = mongo.ObjectId.fromHexString(idUser);
    var update = await widget.db.collection('users').update(
        mongo.where.eq('_id', id), mongo.modify.set('league', _selectedLeague));
  }

//function to redefine our info into textfield
  void defineControllerUser() {
    _nameField.text = myProfil[0].name;
    _emailField.text = myProfil[0].email;
    _passwordField.text = myProfil[0].password;
    _agesField.text = myProfil[0].ages ?? '';
    _phoneNumber.text = myProfil[0].phone ?? '';
    _ffeField.text = myProfil[0].ffe ?? 'https://www.ffe.com/';
    _photoUrl.text = myProfil[0].photoUrl ?? '';
    _selectedLeague = myProfil[0].league ?? _selectedLeague;
  }

  void updateToDatabase() async {
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
        title: const Text('🐴 BabacHorse '),
      ),
      body: isConnected
          ? SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  const SizedBox(height: 80.0),
                  Container(
                      child: GestureDetector(
                    onTap: () {
                      changeValue(_photoUrl, _photoUrl);
                    },
                    child: _photoUrl != ''
                        ? CircleAvatar(
                            radius: 90,
                            backgroundImage: NetworkImage(_photoUrl.text),
                          )
                        : const Icon(Icons.person),
                  )),
                  const SizedBox(height: 50.0),
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
                              DropdownButtonFormField<String>(
                                value: _selectedLeague,
                                validator: (value) {
                                  if (value == '' ||
                                      value == null ||
                                      value == 'Select your league') {
                                    return 'Please select a league';
                                  }
                                  return null;
                                },
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedLeague = value!;
                                    print(_selectedLeague);
                                    defineUserLeague();
                                  });
                                },
                                items: const <DropdownMenuItem<String>>[
                                  DropdownMenuItem<String>(
                                    value: 'Select your league',
                                    child: Text('Select your league'),
                                  ),
                                  DropdownMenuItem(
                                      value: 'Amateur', child: Text('Amateur')),
                                  DropdownMenuItem(
                                      value: 'Club1', child: Text('Club1')),
                                  DropdownMenuItem(
                                      value: 'Club2', child: Text('Club2')),
                                  DropdownMenuItem(
                                      value: 'Club3', child: Text('Club3')),
                                  DropdownMenuItem(
                                      value: 'Club4', child: Text('Club4')),
                                ],
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
                          const SizedBox(height: 50.0),
                          // add button
                          ElevatedButton(
                            onPressed: () {
                              showInfo();
                            },
                            child: const Text('Update'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              getHorses();
                            },
                            child: const Text('Your horses'),
                          )
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

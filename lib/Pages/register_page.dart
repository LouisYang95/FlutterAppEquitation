import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, this.db}) : super(key: key);

  final db;

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _profil = TextEditingController();
  @override
  Widget build(BuildContext context) {
    saveUser() {
      final String username = _usernameController.text.trim();
      final String password = _passwordController.text.trim();
      final String email = _emailController.text.trim();
      final String profil = _profil.text.trim();

      // If the form is valid, save the user in the database
      if (username != '' && password != '' && email != '') {
        // Regexp to check if email is valid
        RegExp emailRegexp = RegExp(
          r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
        RegExp usernameRegexp = RegExp(
          r'^[a-zA-Z0-9]+$');
        // Password should be at least 8 characters long and contain at least one number
        RegExp passwordRegexp = RegExp(
          r'^(?=.*[0-9])(?=.{8,})');
        if (emailRegexp.hasMatch(email) && usernameRegexp.hasMatch(username) && passwordRegexp.hasMatch(password)) {
          // If user email already exist show an alert dialog and don't save the user
          widget.db.collection('users').find({
            'email': email
          }).toList().then((value) {
            if (value.length == 0) {
              widget.db.collection('users').insertOne(<String, dynamic>{
                'username': username,
                'password': password,
                'email': email,
                "is_admin": false,
                // Creation date = Date / Hour only
                'creation_date': DateTime.now().toString().substring(0, 16)
              }).then((value) {
                // Show a popup to confirm the registration
                var popup = showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text(
                            "Success", style: TextStyle(color: Colors.green)),
                        content: Text("You have been registered"),
                      );
                    });
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/login');
                });
                // Clear the fields
                _usernameController.clear();
                _passwordController.clear();
                _emailController.clear();
                return popup;
              });
            } else {
              // If user email already exist show an alert dialog and don't save the user
              var popup = showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text("Error", style: TextStyle(color: Colors.red)),
                      content: Text("User already exists"),
                    );
                  });
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pop();
              });
              _emailController.clear();
              _passwordController.clear();
              return popup;
            }
          });
        } else if (!emailRegexp.hasMatch(email)) {
          // If the email is not valid show a popup
          var popup = showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text("Error", style: TextStyle(color: Colors.red)),
                  content: Text("Invalid email address (should be a valid email address)"),
                );
              });
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
          return popup;
        } else if (!usernameRegexp.hasMatch(username)) {
          // If the username is not valid show a popup
          var popup = showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text("Error", style: TextStyle(color: Colors.red)),
                  content: Text("Invalid username (should contain only letters and numbers)"),
                );
              });
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
          return popup;
        } else if (!passwordRegexp.hasMatch(password)) {
          // If the password is not valid show a popup
          var popup = showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text("Error", style: TextStyle(color: Colors.red)),
                  content: Text("Invalid password (should be 8 characters long with at least one number"),
                );
              });
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
          return popup;
        }
      } else if (username == '' || password == '' || email == '') {
        var popup = showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text("Error", style: TextStyle(color: Colors.red)),
                content: Text("Please fill in all the fields"),
              );
            });
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
        return popup;
      }
    }


    return
      Form(
        key: _formKey,
        child: Container(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
          ),
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 35, top: 30),
                child: Text(
                  'Create\nAccount',
                  style: TextStyle(color: Colors.black, fontSize: 33),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  hintText: "Name",
                                  hintStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: _emailController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              style: TextStyle(color: Colors.black),
                              obscureText: true,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            TextFormField(
                              style: TextStyle(color: Colors.black),
                              obscureText: true,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  hintText: "Profil_picture",
                                  hintStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 27,
                                      fontWeight: FontWeight.w700),
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Color(0xff4c505b),
                                  child: IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        saveUser();
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward,
                                      )),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  child: Text(
                                    'Sign In',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.black,
                                        fontSize: 18),
                                  ),
                                  style: ButtonStyle(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
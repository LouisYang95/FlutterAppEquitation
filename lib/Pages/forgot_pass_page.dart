import 'package:flutter/material.dart';
// Import flutter_session_manager
import 'package:flutter_session_manager/flutter_session_manager.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key, this.db}) : super(key: key);

  final db;


  @override
  _MyForgotPageState createState() => _MyForgotPageState();
}

class _MyForgotPageState extends State<ForgotPasswordPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void changePassword() {
    // Check if user exists and if password is correct
    widget.db.collection('users').find({
      'username': _usernameController.text,
      'email': _emailController.text
    }).toList().then((value) {
      if (value.length == 1) {
        RegExp passwordRegexp = RegExp(
            r'^(?=.*[0-9])(?=.{8,})');
        if (passwordRegexp.hasMatch(_passwordController.text)) {
          widget.db.collection('users').updateOne({
            'username': _usernameController.text,
            'email': _emailController.text
          }, {
            '\$set': {
              'password': _passwordController.text,
              'edition_date': DateTime.now().toString().substring(0, 16)
            }
          });
          Navigator.pushNamed(context, '/login');
        } else {
          // If it's wrong show an alert dialog, make it disappear after 2 seconds
          // And clear the password field
          var popup = showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text("Error", style: TextStyle(color: Colors.red)),
                  content: Text("New Password must be at least 8 characters long and contain at least one number"),
                );
              });
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
          _passwordController.clear();
          return popup;
        }
      } else {
        // If it's wrong show an alert dialog, make it disappear after 2 seconds
        // And clear the password field
        var popup = showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text("Error", style: TextStyle(color: Colors.red)),
                content: Text("Wrong username or password"),
              );
            });
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
        _passwordController.clear();
        return popup;
      }
    });
  }
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Container(
                      padding: EdgeInsets.only(left: 100, top: 130, bottom: 40),
                      child: Text(
                        'Change your \n Password',
                        style: TextStyle(color: Colors.black, fontSize: 33),
                      ),
                    ),
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "Email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _usernameController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "Username",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            Divider(
                            height: 40,
                            thickness: 5,
                            indent: 10,
                            endIndent: 10,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              style: TextStyle(),
                              obscureText: true,
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "New Password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sign in',
                                  style: TextStyle(
                                      fontSize: 27, fontWeight: FontWeight.w700),
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Color(0xff4c505b),
                                  child: IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        changePassword();
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
                                    Navigator.pushNamed(context, '/register');
                                  },
                                  child: Text(
                                    'Sign Up',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xff4c505b),
                                        fontSize: 18),
                                  ),
                                  style: ButtonStyle(),
                                ),
                              ],
                            )
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

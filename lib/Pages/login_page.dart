import 'package:flutter/material.dart';
// Import flutter_session_manager
import 'package:flutter_session_manager/flutter_session_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, this.db}) : super(key: key);

  final db;


  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void checkUser() {
    // Check if user exists and if password is correct
    widget.db.collection('users').find({
      'username': _usernameController.text,
      'password': _passwordController.text
    }).toList().then((value) {
      if (value.length == 1) {
        var session = SessionManager();
        // Set the id of the user in the session and set isLogged to true
        setState(() {
          session.set('id', value[0]['_id']);
          session.set('isLogged', true);
        });
        Navigator.pushNamed(context, '/');
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
                      padding: EdgeInsets.only(left: 120, top: 130, bottom: 40),
                      child: Text(
                        'Welcome\nBack',
                        style: TextStyle(color: Colors.black, fontSize: 33),
                      ),
                    ),
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [

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
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              style: TextStyle(),
                              obscureText: true,
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "Password",
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
                                        checkUser();
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
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Forgot Password',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xff4c505b),
                                        fontSize: 18,
                                      ),
                                    )),
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

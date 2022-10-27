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
          session.set('isAdmin', value[0]['is_admin']);
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
          appBar: AppBar(
            title: const Text('🐴 BabacHorse '),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 60.0),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    color: const Color.fromRGBO(248,105,58, 1),
                    child: const Text("Welcome Back", style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 36)),
                  ),
                  const SizedBox(height: 150.0),
                  Container(
                    margin: const EdgeInsets.only(left: 35, right: 35),
                    child: Column(
                      children: [

                        TextFormField(
                          controller: _usernameController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Username",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          style: const TextStyle(),
                          obscureText: true,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Sign in',
                              style: TextStyle(
                                  fontSize: 27, fontWeight: FontWeight.w700),
                            ),
                            CircleAvatar(
                              radius: 30,
                              child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    checkUser();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                  )),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              style: const ButtonStyle(),
                              child: const Text(
                                'Sign Up',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 18),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/forgot_password');
                                },
                                child: const Text(
                                  'Forgot Password ?',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 18,
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),

          ),
        ],
      ),
          ),
        ),
      ),
    ));
  }
}

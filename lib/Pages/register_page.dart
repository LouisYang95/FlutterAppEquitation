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
  final _profilePictureController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    saveUser() {
      final String username = _usernameController.text.trim();
      final String password = _passwordController.text.trim();
      final String email = _emailController.text.trim();
      String profile_picture = _profilePictureController.text.trim();

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
              if (profile_picture == '') {
                profile_picture = 'https://cdn.discordapp.com/attachments/888356230379212831/1035297732442738698/user.jpeg';
              }
              widget.db.collection('users').insertOne(<String, dynamic>{
                'username': username,
                'password': password,
                'email': email,
                "is_admin": false,
                "photo": profile_picture,
                'creation_date': DateTime.now().millisecondsSinceEpoch
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
                  setState(() {
                  });
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


    return Form(
        key: _formKey,
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
                    child: const Text("Register Now", style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 36)),
                  ),
                  const SizedBox(height: 60.0),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 35, right: 35),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _usernameController,
                                style: const TextStyle(),
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Name",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                controller: _emailController,
                                style: const TextStyle(),
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Email",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                style: const TextStyle(),
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Password",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                controller: _profilePictureController,
                                style: const TextStyle(),
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Link for Profile Picture",
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
                                    'Sign Up',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 27,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  CircleAvatar(
                                    radius: 30,
                                    child: IconButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          saveUser();
                                        },
                                        icon: const Icon(
                                          Icons.arrow_forward,
                                        )),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    style: const ButtonStyle(),
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}
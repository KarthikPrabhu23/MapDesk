// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:map1/Home/home_page.dart';
import 'package:map1/LoginSignup/components/myTextFormField.dart';
import 'package:map1/LoginSignup/components/session_controller.dart';
import 'package:map1/LoginSignup/login_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  DatabaseReference ref = FirebaseDatabase.instance.ref().child('User');

  signInWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text, password: _password.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No User found"),
          ),
        );
      } else if (e.code == 'wrong-password') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wrong password provided"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formKey,
              // height: 700,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  // color: Color.fromARGB(255, 255, 175, 77),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'SignUp Page',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    myTextFormField(
                      MyController: _username,
                      hintText: "Enter username",
                      labelText: "Username",
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    myTextFormField(
                      MyController: _email,
                      hintText: "Enter email id",
                      labelText: "Email ID",
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    myTextFormField(
                      MyController: _password,
                      hintText: "Enter password",
                      labelText: "Password",
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    myTextFormField(
                      MyController: _confirmPassword,
                      hintText: "Confirm password",
                      labelText: "Confirm password",
                      // ObscureText: true,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 250,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: _email.text,
                              password: _password.text,
                            )
                                .then((value) {
                              ref.child(value.user!.uid.toString()).set({
                                'uid': value.user!.uid.toString(),
                                'email': value.user!.email.toString(),
                                'username': _username.text.toString(),
                                'status': '',
                                'profilepic': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOBQGiBzk0bcsHU0V-xMAqi6MWyfc-G_2OrA&usqp=CAU',
                              });

                              SessionController().userid = value.user!.uid;
                              SessionController().username =
                                  _username.text.toString();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyHomePage(),
                                ),
                              );
                            }).catchError((error) {
                              if (error is FirebaseAuthException) {
                                if (error.code == 'email-already-in-use') {
                                  // Handle the case where the email is already in use.
                                  print(
                                      'The email address is already in use by another account.');
                                  // You may want to show a message to the user.
                                  // For example:
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'The email address is already in use.'),
                                    ),
                                  );
                                } else {
                                  // Handle other FirebaseAuthException cases.
                                  print(
                                      'Error ${error.code}: ${error.message}');
                                }
                              } else {
                                // Handle other types of errors.
                                print('Unexpected error: $error');
                              }
                            });
                          }
                        },
                        child: const Text(
                          "SignUp",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Not a new user? ',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          child: Text(
                            'Login here',
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

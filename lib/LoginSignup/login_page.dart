// ignore_for_file: use_build_context_synchronously, unused_import, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:map1/Home/home_page.dart';
import 'package:map1/LoginSignup/components/myTextFormField.dart';
import 'package:map1/LoginSignup/components/session_controller.dart';
import 'package:map1/LoginSignup/reset_password.dart';
import 'package:map1/LoginSignup/signup_page.dart';
// import 'package:map1/LoginSignup/auth_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final _username = TextEditingController();
  final _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();

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

  void signUserIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _email.text,
      password: _password.text,
    );
  }

  @override
  dispose() {
    super.dispose();
    _email;
    _formKey;
    _password;
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
                      'Login Page',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 23),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ResetPassword()),
                              );
                            },
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                                .signInWithEmailAndPassword(
                              email: _email.text,
                              password: _password.text,
                            )
                                .then((value) {
                              SessionController().userid = value.user!.uid;
                              // SessionController().username =
                              //     value.user!.username;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyHomePage(),
                                ),
                              );
                            }).catchError(
                              (error) {
                                print("Error ${error.toString()}");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error.toString()),
                                  ),
                                );
                              },
                            );
                          }
                        },
                        child: const Text(
                          "Login",
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
                          'New user? ',
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
                                  builder: (context) => const SignUp()),
                            );
                          },
                          child: Text(
                            'SignUp here',
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

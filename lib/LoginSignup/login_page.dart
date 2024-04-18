// ignore_for_file: use_build_context_synchronously, unused_import, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map1/Home/home_page.dart';
import 'package:map1/LoginSignup/components/myTextFormField.dart';
import 'package:map1/LoginSignup/components/session_controller.dart';
import 'package:map1/LoginSignup/components/widgets.dart';
import 'package:map1/LoginSignup/reset_password.dart';
import 'package:map1/LoginSignup/signup_page.dart';
import 'package:map1/bottom_navigation_bar.dart';
import 'package:map1/components/helper.dart';
import 'package:map1/main.dart';
import 'package:map1/service/auth_service.dart';
import 'package:map1/service/database_service.dart';
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

  String email = "";
  String password = "";
  AuthService authService = AuthService();

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
    // _email;
    // _formKey;
    // _password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 106, 69, 185),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            // height: 700,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 49, 42, 129),
                    Color.fromARGB(255, 71, 25, 145)
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      appName,
                      style: GoogleFonts.dmSerifDisplay(
                        textStyle: const TextStyle(
                          fontSize: 61,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 3,
                            child: Container(
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                    Colors.white,
                                    Color.fromARGB(255, 71, 25, 145)
                                  ],
                                      begin: Alignment.centerRight,
                                      end: Alignment.centerLeft)),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 15,
                                color: Colors.white,
                              ),
                              Icon(
                                Icons.star,
                                size: 30,
                                color: Colors.white,
                              ),
                              Icon(
                                Icons.star,
                                size: 15,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 3,
                            child: Container(
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                    Colors.white,
                                    Color.fromARGB(255, 71, 25, 145)
                                  ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      'Login Page',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 223, 223, 223),
                          fontSize: 24),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // Image.asset("lib/images/user.png"),
                    const SizedBox(height: 10),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: textInputDecoration.copyWith(
                          labelText: "Email",
                          focusColor: Colors.white,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.white,
                          )),
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },

                      // check tha validation
                      validator: (val) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val!)
                            ? null
                            : "Please enter a valid email";
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      decoration: textInputDecoration.copyWith(
                          labelText: "Password",
                          focusColor: Colors.white,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.white,
                          )),
                      validator: (val) {
                        if (val!.length < 6) {
                          return "Password must be at least 6 characters";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
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
                                  color: Colors.white54),
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
                          login();

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const MyHomePage(),
                          //   ),
                          // );
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

  login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {});
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          nextScreenReplace(context, MyBottomNavigationBar());
          // nextScreenReplace(context, MyHomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {});
        }
      });
    }
  }
}

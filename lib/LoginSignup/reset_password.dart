import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map1/LoginSignup/components/widgets.dart';
import 'package:map1/LoginSignup/login_page.dart';
import 'package:map1/LoginSignup/signup_page.dart';
import 'package:map1/main.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 106, 69, 185),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
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
                    children: [
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
                        height: 45,
                      ),
                      const Text(
                        'Forgot Password?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 223, 223, 223),
                            fontSize: 24),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      // myTextFormField(
                      //   MyController: _email,
                      //   hintText: "Enter email id",
                      //   labelText: "Email ID",
                      // ),
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
                      const SizedBox(
                        height: 15,
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Check your email inbox'),
                                ),
                              );
                              FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: _email.text)
                                  .then((value) => Navigator.of(context).pop());
                            }
                          },
                          child: const Text(
                            "Forgot password",
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
                            'Remembered password? ',
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
                                  builder: (context) => const LoginPage(),
                                ),
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
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      const Divider(
                        thickness: 2,
                        color: Colors.white70,
                        indent: 44,
                        endIndent: 44,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'New User? ',
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
      ),
    );
  }
}

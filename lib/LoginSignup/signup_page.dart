import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:map1/LoginSignup/components/myTextFormField.dart';

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
      backgroundColor: Colors.grey[300],
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
                        MyController: _username, hintText: "Enter username", labelText: "Username",),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 25),
                      child: OverflowBar(
                        overflowSpacing: 13,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _username,
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Username is empty';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Username',
                              hintText: 'Enter username',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                ),
                                // borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _username,
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Username is empty';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'username',
                              hintText: 'Enter username',
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: _username,
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Username is empty';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'username',
                              hintText: 'Enter username',
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: _username,
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Username is empty';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'username',
                              hintText: 'Enter username',
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signInWithEmailAndPassword();
                          }
                        },
                        child: const Text(
                          "SignUp",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    )
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

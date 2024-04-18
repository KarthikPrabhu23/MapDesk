// ignore_for_file: use_build_context_synchronously, avoid_print, unused_import
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:map1/Chat/chat_page.dart';
import 'package:map1/Chat/chat_screen.dart';
import 'package:map1/Home/home_page.dart';
import 'package:map1/LoginSignup/components/emailIconField.dart';
import 'package:map1/LoginSignup/components/myTextFormField.dart';
import 'package:map1/LoginSignup/components/session_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:map1/LoginSignup/components/widgets.dart';
import 'package:map1/LoginSignup/login_page.dart';
import 'package:map1/bottom_navigation_bar.dart';
import 'package:map1/components/helper.dart';
import 'package:map1/main.dart';
import 'package:map1/service/auth_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('User');
  String userUID = "";
  String dpUrl =
      "https://firebasestorage.googleapis.com/v0/b/map1-6175b.appspot.com/o/pfp.png?alt=media&token=e3be88e8-d50c-491d-b52f-2f6c7843fbbc";

  final _confirmPassword = TextEditingController();
  final _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _username = TextEditingController();
  final _picker = ImagePicker();

  String email = "";
  String password = "";
  String fullName = "";
  AuthService authService = AuthService();

  void pickUploadImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 90,
    );

    Reference ref1 =
        FirebaseStorage.instance.ref().child('${DateTime.now()}DP.jpg');

    await ref1.putFile(File(image!.path));

    ref1.getDownloadURL().then((value) {
      print('Profile picture uploaded on FirebaseStorage, link is ');
      print(value);
      setState(() {
        dpUrl = value;
        HelperFunctions.saveUserDPurl(dpUrl);
        print('dpUrl is ');
        print(dpUrl);
      });
    });
  }

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
  void dispose() {
    super.dispose();
    _confirmPassword;
    _email;
    _password;
    _picker;
    _formKey;
    _username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 106, 69, 185),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                      height: 3,
                    ),
                    Text(
                      appName,
                      style: GoogleFonts.dmSerifDisplay(
                        textStyle: const TextStyle(
                          fontSize: 50,
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
                            height: 2,
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
                                size: 10,
                                color: Colors.white,
                              ),
                              Icon(
                                Icons.star,
                                size: 20,
                                color: Colors.white,
                              ),
                              Icon(
                                Icons.star,
                                size: 10,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 2,
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
                      height: 3,
                    ),
                    const Text(
                      'SignUp Page',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    GestureDetector(
                      onTap: () {
                        pickUploadImage();
                      },
                      child: Container(
                        width: 90,
                        height: 90,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: dpUrl == " "
                            ? Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 41, 36, 36),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 70,
                                    color: Color.fromARGB(255, 228, 225, 225),
                                  ),
                                ),
                              )
                            : Image.network(dpUrl),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: textInputDecoration.copyWith(
                        labelText: "Username",
                        focusColor: Colors.white,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.person_outlined,
                          color: Colors.white,
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          // password = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: textInputDecoration.copyWith(
                        labelText: "Full Name",
                        focusColor: Colors.white,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          fullName = val;
                          HelperFunctions.saveUserDPurl(dpUrl);
                        });
                      },
                      validator: (val) {
                        if (val!.isNotEmpty) {
                          return null;
                        } else {
                          return "Name cannot be empty";
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                        ),
                      ),
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
                    const SizedBox(height: 10),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      cursorColor: Colors.white,
                      decoration: textInputDecoration.copyWith(
                        labelText: "Password",
                        focusColor: Colors.white,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                      ),
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
                    const SizedBox(
                      height: 10,
                    ),
                    
                    // myTextFormField(
                    //   MyController: _email,
                    //   hintText: "Enter email id",
                    //   labelText: "Email ID",
                    // ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    // myTextFormField(
                    //   MyController: _password,
                    //   hintText: "Enter password",
                    //   labelText: "Password",
                    // ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    // myTextFormField(
                    //   MyController: _confirmPassword,
                    //   hintText: "Confirm password",
                    //   labelText: "Confirm password",
                    //   // ObscureText: true,
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 250,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          register();

                          // if (_formKey.currentState!.validate()) {
                          //   // _uploadImage();
                          //   FirebaseAuth.instance
                          //       .createUserWithEmailAndPassword(
                          //     email: _email.text,
                          //     password: _password.text,
                          //   )
                          // .then((value) {
                          // ref.child(value.user!.uid.toString()).set(
                          //   {
                          //     'uid': value.user!.uid.toString(),
                          //     'email': value.user!.email.toString(),
                          //     'username': _username.text.toString(),
                          //     'status': '',
                          //   },
                          // );
                          //     // _uploadImage;
                          // FirebaseFirestore.instance
                          //     .collection('users')
                          //     .doc(value.user!.uid.toString())
                          //     .set(
                          //   {
                          //     // 'location': {
                          //     //   'lat': latitude,
                          //     //   'lng': longitude,
                          //     //   'timestamp':
                          //     //       firestore.FieldValue.serverTimestamp(),
                          //     // },
                          //     // 'emailid': emailId,
                          //     // 'name': ufullname,
                          //     'email': _email.text.toString(),
                          //     'username': _username.text.toString(),
                          //     'status': '',
                          //     'profilepic': dpUrl,
                          //     'targetCompletionCount': 0,
                          //   },
                          // );
                          // SessionController().userid = value.user!.uid;
                          // SessionController().username =
                          //     _username.text.toString();

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const MyHomePage(),
                          //   ),
                          // );

                          //   }).catchError(
                          //     (error) {
                          //       if (error is FirebaseAuthException) {
                          //         if (error.code == 'email-already-in-use') {
                          //           // Handle the case where the email is already in use.
                          //           print(
                          //               'The email address is already in use by another account.');
                          //           ScaffoldMessenger.of(context).showSnackBar(
                          //             const SnackBar(
                          //               content: Text(
                          //                   'The email address is already in use.'),
                          //             ),
                          //           );
                          //         } else {
                          //           // Handle other FirebaseAuthException cases.
                          //           print(
                          //               'Error ${error.code}: ${error.message}');
                          //         }
                          //       } else {
                          //         print('Unexpected error: $error');
                          //       }
                          //     },
                          //   );
                          // }
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
                      height: 5,
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {});
      await authService
          .registerUserWithEmailandPassword(
              fullName, _username.text.toString(), dpUrl, email, password)

          // await FirebaseAuth.instance
          //     .createUserWithEmailAndPassword(
          //   email: email,
          //   password: password,
          // )
          .then((value) async {
        await HelperFunctions.saveUserLoggedInStatus(true);
        await HelperFunctions.saveUserEmailSF(email);
        await HelperFunctions.saveUserNameSF(fullName);
        // _uploadImage;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyBottomNavigationBar(),
          ),
        );

        // nextScreenReplace(context, const ChatScreen());
      });
    }
  }
}

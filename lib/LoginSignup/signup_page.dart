// ignore_for_file: use_build_context_synchronously, avoid_print, unused_import
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:map1/Home/home_page.dart';
import 'package:map1/LoginSignup/components/emailIconField.dart';
import 'package:map1/LoginSignup/components/myTextFormField.dart';
import 'package:map1/LoginSignup/components/session_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:map1/LoginSignup/login_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('User');
  String userUID = "";
  // static String downloadUrl = "";
  String dpUrl = " ";

  final _confirmPassword = TextEditingController();
  final _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _username = TextEditingController();

  final _picker = ImagePicker();

  late PickedFile _image;

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = PickedFile(pickedFile.path);
      });
    } else {
      // Handle the case where no image was picked
      // You may display a message to the user or perform any other appropriate action
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      // Handle the case where no image has been selected
      return;
    }

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage
        .ref()
        .child("profilepic")
        .child('${DateTime.now()}.jpg'); // Add file extension if needed
    UploadTask uploadTask = ref.putFile(File(_image.path));
    // TaskSnapshot snapshot = await uploadTask;
    // downloadUrl = await snapshot.ref.getDownloadURL();

    // Store the download URL in Firestore or wherever needed
  }

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
        // Update the state variables here
        dpUrl = value;
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
                    // InkWell(
                    //   onTap: _pickImage,
                    //   child: Icon(
                    //     Icons.add_a_photo,
                    //     size: 50,
                    //   ),
                    // ),
                    // _image != null
                    //     ? Image.file(
                    //         File(_image.path),
                    //         height: 200,
                    //       )
                    //     : const Placeholder(
                    //         fallbackHeight: 200,
                    //       ),
                    // ElevatedButton(
                    //   onPressed: (){

                    //   },
                    //   // onPressed: _pickImage,
                    //   child: const Text('Pick Image'),
                    // ),
                    GestureDetector(
                      onTap: () {
                        pickUploadImage();
                      },
                      child: Container(
                        width: 120,
                        height: 120,
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
                    // EmailInputFieldIcon(
                    //   _email,
                    //   inputController: _email,
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
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
                            // _uploadImage();
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: _email.text,
                              password: _password.text,
                            )
                                .then((value) {
                              ref.child(value.user!.uid.toString()).set(
                                {
                                  'uid': value.user!.uid.toString(),
                                  'email': value.user!.email.toString(),
                                  'username': _username.text.toString(),
                                  'status': '',
                                  //  'profilepic': downloadUrl,
                                  // 'profilepic':
                                  //     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOBQGiBzk0bcsHU0V-xMAqi6MWyfc-G_2OrA&usqp=CAU',
                                },
                              );
                              // _uploadImage;
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(value.user!.uid.toString())
                                  .set(
                                {
                                  // 'location': {
                                  //   'lat': latitude,
                                  //   'lng': longitude,
                                  //   'timestamp':
                                  //       firestore.FieldValue.serverTimestamp(),
                                  // },
                                  // 'emailid': emailId,
                                  // 'name': ufullname,
                                  'email': _email.text.toString(),
                                  'username': _username.text.toString(),
                                  'status': '',
                                  'profilepic': dpUrl,
                                  // 'fullname': ufullname,
                                },
                              );
                              SessionController().userid = value.user!.uid;
                              SessionController().username =
                                  _username.text.toString();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyHomePage(),
                                ),
                              );
                            }).catchError(
                              (error) {
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
                              },
                            );
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
}

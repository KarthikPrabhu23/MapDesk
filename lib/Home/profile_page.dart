// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:map1/LoginSignup/components/session_controller.dart';
import 'package:map1/LoginSignup/signup_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ref = FirebaseDatabase.instance.ref().child('User');

  // FirebaseAuth auth = FirebaseAuth.instance;
  // final user = auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          SessionController().userid.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then(
                (value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const SignUp()),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: ref.child(SessionController().userid.toString()).onValue,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                print(snapshot.data.snapshot.value);
                Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Center(
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.amber,
                                width: 5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: map['profilepic'].toString() == ""
                                  ? const Icon(
                                      Icons.person,
                                      size: 85,
                                    )
                                  : Image(
                                      fit: BoxFit.cover,
                                      image: const NetworkImage(
                                          'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=600'),
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: const CircleAvatar(
                            radius: 16,
                            child: Icon(Icons.edit,
                                size: 16, color: Colors.black54),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ReuseableRow(
                        title: 'Username',
                        icondata: Icons.person,
                        value: map['username']),
                    ReuseableRow(
                        title: 'Email',
                        icondata: Icons.mail,
                        value: map['email']),
                    // ReuseableRow(title: 'Phone Number', icondata: Icons.phone  , value: map['phone']),
                    ReuseableRow(
                      title: 'Status',
                      icondata: Icons.mark_chat_unread,
                      value: map['status'],
                    ),
                    ReuseableRow(
                      title: 'Latitude',
                      icondata: Icons.pin_drop_outlined,
                      value: map['latitude'].toString(),
                    ),
                    ReuseableRow(
                      title: 'Longitude',
                      icondata: Icons.pin_drop,
                      value: map['longitude'].toString(),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ReuseableRow extends StatelessWidget {
  const ReuseableRow(
      {super.key,
      required this.title,
      required this.icondata,
      required this.value});

  final IconData icondata;
  final String title, value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          leading: Icon(icondata),
          trailing: Text(
            value,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ),
        const Divider(
          color: Colors.black38,
        ),
      ],
    );
  }
}

// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:map1/LoginSignup/components/session_controller.dart';
import 'package:map1/LoginSignup/login_page.dart';
import 'package:map1/my_colors.dart';
import 'package:map1/service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ref = FirebaseDatabase.instance.ref().child('User');

  AuthService authService = AuthService();

  @override
  void dispose() {
    super.dispose();
    // ref.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 62,
         iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Your Profile',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        // title: Text(
        //   SessionController().userid.toString(),
        //   style: const TextStyle(
        //     fontWeight: FontWeight.bold,
        //     color: Colors.white,
        //   ),
        // ),
        actions: [
          IconButton(
            onPressed: () async {
              FirebaseAuth.instance.signOut();
              await authService.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (route) => false);
            },
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(SessionController().userid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                    child: Text('User data not found'),
                  );
                } else {
                  Map<String, dynamic> userData =
                      snapshot.data!.data() as Map<String, dynamic>;
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
                                  color: MyColors.ButtonBlue,
                                  width: 5,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: userData['profilepic'].toString().isEmpty
                                    ? const Icon(
                                        Icons.person,
                                        size: 85,
                                      )
                                    : Image.network(
                                        userData['profilepic'],
                                        fit: BoxFit.cover,
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
                          // InkWell(
                          //   onTap: () {
                          //     // Handle edit profile picture
                          //   },
                          //   child: const CircleAvatar(
                          //     radius: 16,
                          //     child: Icon(Icons.edit,
                          //         size: 16, color: Colors.black54),
                          //   ),
                          // )
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      ReuseableRow(
                        title: 'Username',
                        icondata: Icons.person,
                        value: userData['username'],
                      ),
                      ReuseableRow(
                        title: 'Email',
                        icondata: Icons.mail,
                        value: userData['email'],
                      ),
                      const ReuseableRow(
                        title: 'Phone Number',
                        icondata: Icons.phone,
                        value: "123456789",
                      ),
                      // ReuseableRow(
                      //   title: 'Status',
                      //   icondata: Icons.mark_chat_unread,
                      //   value: userData['status'],
                      // ),
                      ReuseableRow(
                        title: 'Latitude',
                        icondata: Icons.pin_drop_outlined,
                        value: userData['location']['lat'].toString(),
                      ),
                      ReuseableRow(
                        title: 'Longitude',
                        icondata: Icons.pin_drop,
                        value: userData['location']['lng'].toString(),
                      ),
                      Text(
                        SessionController().userid.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
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

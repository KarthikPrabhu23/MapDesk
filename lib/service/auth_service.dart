
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map1/components/helper.dart';
import 'package:map1/service/database_service.dart';
import 'package:map1/LoginSignup/components/session_controller.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      SessionController().userid = user.uid;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // register
  Future registerUserWithEmailandPassword(
      String fullName, String username, String dpUrl, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid.toString())
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
              'email': email,
              'username': username,
              'fullName' : fullName,
              'status': '',
              'profilepic': dpUrl,
              'targetCompletionCount': 0,
            },
          );

          
          FirebaseFirestore.instance
              .collection('ChatUsers')
              .doc(user.uid.toString())
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
              'email': email,
              'username': username,
              'status': '',
              'profilepic': dpUrl,
              'targetCompletionCount': 0,
            },
          );


          SessionController().userid = user.uid;
          SessionController().username = username;
      if (user != null) {
        // call our database service to update the user data.
        await DatabaseService(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // signout
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}

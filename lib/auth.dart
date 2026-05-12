import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/bottomnav.dart';
import 'package:first_project/database.dart';
import 'package:first_project/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn
          .signIn();

      if (googleSignInAccount == null) return;

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      UserCredential result = await firebaseAuth.signInWithCredential(
        credential,
      );
      User? userDetails = result.user;

      if (userDetails != null) {
        await SharedPreferenceHelper().saveUserEmail(userDetails.email ?? '');
        await SharedPreferenceHelper().saveUserId(userDetails.uid);
        await SharedPreferenceHelper().saveUserImage(
          userDetails.photoURL ?? '',
        );
        await SharedPreferenceHelper().saveUserName(
          userDetails.displayName ?? '',
        );

        // ✅ FIX: Check karo user pehle se exist karta hai ya nahi
        DocumentSnapshot existingUser = await FirebaseFirestore.instance
            .collection("users")
            .doc(userDetails.uid)
            .get();

        if (!existingUser.exists) {
          // ✅ Sirf pehli baar naya document banao Points = "0" ke saath
          Map<String, dynamic> userInfoMap = {
            "email": userDetails.email,
            "name": userDetails.displayName,
            "image": userDetails.photoURL,
            "id": userDetails.uid,
            "Points": "0",
          };
          await DatabaseMethods().addUserInfo(userInfoMap, userDetails.uid);
          print("✅ New user created with Points = 0");
        } else {
          // ✅ Pehle se user hai — sirf name/email/image update karo, Points mat chhuo!
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userDetails.uid)
              .update({
                "email": userDetails.email,
                "name": userDetails.displayName,
                "image": userDetails.photoURL,
              });
          print(
            "✅ Existing user — Points preserved: ${existingUser["Points"]}",
          );
        }

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNav()),
          );
        }
      }
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Sign-in failed. Please try again.",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        );
      }
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  Future<void> deleteUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.delete();
  }
}

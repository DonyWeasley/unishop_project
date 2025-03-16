import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shopsmart_users_en/services/assets_manager.dart';

import '../../root_screen.dart';
import '../../services/my_app_functions.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  // ฟังก์ชันสำหรับล็อกอินด้วย Google
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> _googleSignSignIn({required BuildContext context}) async {
    try {
      final authResults = await signInWithGoogle();

      // เช็คว่าผู้ใช้เป็นผู้ใช้ใหม่หรือไม่
      if (authResults.additionalUserInfo!.isNewUser) {
        await FirebaseFirestore.instance.collection("users").doc(authResults.user!.uid).set({
          'userId': authResults.user!.uid,
          'userName': authResults.user!.displayName,
          'userImage': authResults.user!.photoURL ?? AssetsManager.shoppingCart,
          'userEmail': authResults.user!.email,
          'createdAt': Timestamp.now(),
          'userWish': [],
          'userCart': [],
        });
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.pushReplacementNamed(context, RootScreen.routeName);
        });
      }
    } on FirebaseException catch (error) {
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: error.message.toString(),
        fct: () {},
      );
    } catch (error) {
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: error.toString(),
        fct: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        padding: const EdgeInsets.all(12.0),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      icon: const Icon(
        Ionicons.logo_google,
        color: Colors.red,
      ),
      label: const Text(
        "Sign in with google",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () async {
        await _googleSignSignIn(context: context);
      },
    );
  }
}

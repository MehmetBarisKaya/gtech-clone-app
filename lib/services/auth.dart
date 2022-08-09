import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtech/model/user.dart';
import 'package:gtech/widgets/custom_alertdialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final String defaultImage =
      "https://firebasestorage.googleapis.com/v0/b/gtech-clone.appspot.com/o/profileImages%2Fdefault-avatar.jpg?alt=media&token=946d0344-731f-47e1-b5bf-18f76c4c4179";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future signIn(String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showAlertDialog(
            context: context,
            contentText: "User not found",
            titleText: "Error!");
      } else if (e.code == 'wrong-password') {
        showAlertDialog(
            context: context,
            contentText: "Wrong password",
            titleText: "Error!");
      }
    } catch (e) {
      showAlertDialog(
          context: context,
          contentText: "Something went wrong!",
          titleText: "Error!");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> register(
      {required String email,
      required String password,
      required String name,
      required String phoneNumber,
      String? imageUrl,
      required BuildContext context}) async {
    try {
      UserCredential credResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credResult.user;
      UserModel _user = UserModel(
        uid: user!.uid,
        phoneNumber: phoneNumber,
        email: email,
        name: name,
        imageUrl: imageUrl ?? defaultImage,
      );

      await _firestore.collection("users").doc(user.uid).set(_user.toJson());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showAlertDialog(
            context: context,
            contentText: "Weak password",
            titleText: "Error!");
      } else if (e.code == 'email-already-in-use') {
        showAlertDialog(
            context: context,
            contentText: "Email already use!",
            titleText: "Error!");
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return UserModel.fromSnap(documentSnapshot);
  }
}

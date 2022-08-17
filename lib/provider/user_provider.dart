import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gtech/model/user.dart';
import 'package:gtech/services/auth.dart';

import '../widgets/custom_alertdialog.dart';

class UserProvider with ChangeNotifier {
  final String defaultImage =
      "https://firebasestorage.googleapis.com/v0/b/gtech-clone.appspot.com/o/profileImages%2Fdefault-avatar.jpg?alt=media&token=946d0344-731f-47e1-b5bf-18f76c4c4179";

  UserModel? _user;
  bool? isAuth;
  //String? _userId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//%%%%%%%%%%%%
  Stream<DocumentSnapshot> streamDataCollection() {
    return _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .snapshots();
  }

  Future getData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .get();
      if (snap != null) {
        _user = UserModel.fromJson(snap.data()!);
      }
      print(_user?.email);

      //_user = UserModel.fromSnap(snap);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
    //name = (snap.data() as Map<String, dynamic>)["name"];
  }

  UserModel? get userDataModel {
    return _user;
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
}

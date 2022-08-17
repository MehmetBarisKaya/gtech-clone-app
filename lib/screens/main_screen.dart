import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtech/screens/home_screen.dart';
import 'package:gtech/screens/login_screen.dart';
import 'package:gtech/services/auth.dart';

import '../model/user.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snp) {
          if (snp.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snp.hasData) {
            return _buildHomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }

  StreamBuilder<DocumentSnapshot<Object?>> _buildHomeScreen() {
    return StreamBuilder(
        stream: AuthService().streamDataCollection(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text("$snapshot");
          } else if (snapshot.hasData) {
            UserModel? userdata = UserModel.fromSnap(snapshot.data);
            return userdata.uid == null
                ? const Center(child: Text("No user"))
                : HomeScreen(userModel: userdata);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

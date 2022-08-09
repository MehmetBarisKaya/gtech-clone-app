import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtech/model/user.dart';
import 'package:gtech/services/auth.dart';

import '../widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? userData;
  final user = FirebaseAuth.instance.currentUser!;

  void getData() async {
    var snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    setState(() {
      userData = UserModel.fromSnap(snap);
    });

    //name = (snap.data() as Map<String, dynamic>)["name"];
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Screen"),
      ),
      drawer: NavigationDrawer(
        userData: userData!,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Signed in ${user.email!}"),
            ElevatedButton(
              onPressed: () {
                AuthService().signOut();
              },
              child: const Text("Sign Out"),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => ProfileScreen(
            //                 userModel: userData,
            //               )),
            //     );
            //   },
            //   child: const Text("Profile"),
            // )
          ],
        ),
      ),
    );
  }
}

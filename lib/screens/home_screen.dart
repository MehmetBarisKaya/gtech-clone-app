import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtech/model/user.dart';
import 'package:gtech/provider/user_provider.dart';
import 'package:gtech/services/auth.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //UserModel? userData;
  final user = FirebaseAuth.instance.currentUser!;

  Future<void> getUSerData(BuildContext context) async {
    await Provider.of<UserProvider>(context).getData();
  }

  // void getData() async {
  //   var snap = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user.uid)
  //       .get();
  //   setState(() {
  //     userData = UserModel.fromSnap(snap);
  //   });

  //   //name = (snap.data() as Map<String, dynamic>)["name"];
  // }

  @override
  void initState() {
    super.initState();
    //getData();
  }

  @override
  void didChangeDependencies() {
    getUSerData(context);

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Main Screen"),
        ),
        drawer: const NavigationDrawer(
            //userData: user.userDataModel,
            ),
        body: FutureBuilder(
            future: getUSerData(context),
            builder: (context, snapshot) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Signed in ${user.userDataModel.name}"),
                  ],
                ),
              );
            }));
  }
}

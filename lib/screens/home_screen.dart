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
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshUser(BuildContext context) async {
    await Provider.of<UserProvider>(context).getData();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<UserProvider>(context).getData().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Screen"),
      ),
      drawer: const NavigationDrawer(
          //userData: user.userDataModel,
          ),
      body: FutureBuilder(
          future: _refreshUser(context),
          builder: (context, snapshot) {
            return _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(userData.userDataModel.name!),
                      ],
                    ),
                  );
          }),
    );
  }
  //);
}
//}

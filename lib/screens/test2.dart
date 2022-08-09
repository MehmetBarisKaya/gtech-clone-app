import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtech/services/auth.dart';
import 'package:image_picker/image_picker.dart';

class Test extends StatefulWidget {
  const Test({required this.uid, Key? key}) : super(key: key);

  final String uid;

  @override
  State<Test> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Test> {
  String? _name;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    //print("${user.email}");
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .get();
    _name = userDoc.get("name");
    print("${userDoc}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Column(
        children: [
          _buildHeader(context),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        children: [
          CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor, radius: 52),
          const SizedBox(
            height: 12,
          ),
          Text(_name!),
        ],
      ),
    );
  }
}

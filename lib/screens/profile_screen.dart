import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gtech/model/user.dart';
import 'package:gtech/services/storage.dart';
import 'package:gtech/utils/utils.dart';
import 'package:gtech/widgets/profile_details.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel userModel;
  const ProfileScreen({required this.userModel, Key? key}) : super(key: key);

  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<ProfileScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  File? _photo;
  bool _isVisible = true;

  void _changeVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Future imgFromGallery(BuildContext context) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        //uploadFile(context);
        StorageServices().uploadImage(widget.userModel.uid, _photo!);
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera(BuildContext context) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        //uploadFile(context);
        StorageServices().uploadImage(widget.userModel.uid, _photo!);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile(BuildContext context) async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child('file/');
      await ref.putFile(_photo!);
    } catch (e) {
      showSnackBar(context, "Something went wrong!");
    }
  }

  Center buildImagePicker(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _showPicker(context);
        },
        child: CircleAvatar(
          radius: 55,
          child: _photo != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                    _photo!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.fitHeight,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50)),
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      imgFromGallery(context);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera(context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //UserModel user = Provider.of<UserProvider>(context).getUser;
    //print(user);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildImagePicker(context),
            const Divider(),
            ProfileDetails(
                name: widget.userModel.name,
                email: widget.userModel.email,
                phoneNumber: widget.userModel.phoneNumber),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: _isVisible,
                  child: ElevatedButton(
                      onPressed: () {}, child: const Text("Update")),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gtech/model/user.dart';
import 'package:gtech/services/auth.dart';
import 'package:gtech/services/storage.dart';
import 'package:gtech/utils/contants.dart';
import 'package:gtech/utils/utils.dart';
import 'package:gtech/widgets/validator.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import '../widgets/formtextfield.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel userModel;
  const ProfileScreen({required this.userModel, Key? key}) : super(key: key);

  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<ProfileScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  File? _photo;

  String? url;

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
        //uploadImage(widget.userModel.uid, _photo!);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImage(String id, File file) async {
    var reference = storage.ref().child("profileImages/$id");
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => null); //this will upload image
    url = await taskSnapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"imageUrl": url});
  }

  Future imgFromCamera(BuildContext context) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        //uploadFile(context);
        StorageServices().uploadImage(widget.userModel.uid!, _photo!);
      } else {
        print('No image selected.');
      }
    });
  }

  Center buildImagePicker(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _showPicker(context);
        },
        child: CircleAvatar(
            radius: 70,
            child: _photo != null
                ? CircleAvatar(
                    radius: profilePictureRadius,
                    backgroundImage: FileImage(_photo!),
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: profilePictureRadius,
                        backgroundImage:
                            NetworkImage(widget.userModel.imageUrl!),
                      ),
                      const Icon(Icons.add_a_photo)
                    ],
                  )),
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
        padding: kDefaultPadding,
        child: Center(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildImagePicker(context),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FormTextField(
                          controller: _nameController,
                          labelText: widget.userModel.name!,
                          icon: const Icon(Icons.info_outline)),
                      const SizedBox(
                        height: 10,
                      ),
                      FormTextField(
                          controller: _phoneNumberController,
                          labelText: widget.userModel.phoneNumber!,
                          icon: const Icon(Icons.info_outline)),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          // // setState(() {
                          // //   uploadImage(widget.userModel.uid!, _photo!);
                          // // });
                          // if (_formKey.currentState!.validate()) {
                          //   print(_nameController.text);
                          //   print(_phoneNumberController.text);
                          //   //   AuthService().update(
                          //   //       uid: widget.userModel.uid!,
                          //   //       name: _nameController.text.trim(),
                          //   //       phoneNumber:
                          //   //           _phoneNumberController.text.trim());
                          // }
                        },
                        child: const Text("Update")),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

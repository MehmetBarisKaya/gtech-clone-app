import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtech/model/user.dart';
import 'package:gtech/provider/user_provider.dart';
import 'package:gtech/services/auth.dart';
import 'package:gtech/services/storage.dart';
import 'package:gtech/utils/contants.dart';
import 'package:gtech/widgets/validator.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';

import '../widgets/formtextfield.dart';

class ProfileScreen extends StatefulWidget {
  //final UserModel userModel;
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<ProfileScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;
  late Future _userFuture;

  Future _obtainUserFuture() async {
    return await Provider.of<UserProvider>(context, listen: false).getData();
  }

  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  File? _photo;
  String? name;
  String? phoneNumber;
  String? url;

  @override
  void initState() {
    _userFuture = _obtainUserFuture();
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
    try {
      var reference = storage.ref().child("profileImages/$id");
      UploadTask uploadTask = reference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      //onError
      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .update({"imageUrl": url});
    } on Exception catch (e) {}
  }

  Future imgFromCamera(BuildContext context) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        //uploadFile(context);
        //StorageServices().uploadImage(widget.userModel.uid!, _photo!);
      } else {
        print('No image selected.');
      }
    });
  }

  Center buildImagePicker(BuildContext context, UserModel userModel) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _showPicker(context, userModel);
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
                        backgroundImage: NetworkImage(userModel.imageUrl!),
                      ),
                      const Icon(Icons.add_a_photo)
                    ],
                  )),
      ),
    );
  }

  void _showPicker(BuildContext context, UserModel userModel) {
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

  _saveForm(UserModel userModel) {
    if (_photo != null) {
      setState(() {
        uploadImage(userModel.uid!, _photo!);
      });
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AuthService()
          .update(uid: userModel.uid!, name: name!, phoneNumber: phoneNumber!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update User"),
      ),
      body: FutureBuilder(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.error != null) {
              //Do error handling stuff
              return const Center(
                child: Text("An error accured!"),
              );
            } else {
              return Padding(
                padding: kDefaultPadding,
                child: Consumer<UserProvider>(
                  builder: (context, value, child) => Center(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildImagePicker(context, value.userDataModel!),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FormTextField(
                                      onSaved: (value) {
                                        name = value!;
                                      },
                                      validator: FormValidator().isEmpty,
                                      initialValue: value.userDataModel!.name,
                                      icon: const Icon(Icons.info_outline)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  FormTextField(
                                      onSaved: (value) {
                                        phoneNumber = value!;
                                      },
                                      validator: FormValidator().isEmpty,
                                      initialValue:
                                          value.userDataModel!.phoneNumber,
                                      icon: const Icon(Icons.info_outline)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    _saveForm(value.userDataModel!);
                                    Navigator.pop(context);
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
          }),
    );
  }
}

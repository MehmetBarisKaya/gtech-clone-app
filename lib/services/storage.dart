import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';

class StorageServices {
  // final firebase_storage.FirebaseStorage storage =
  //     firebase_storage.FirebaseStorage.instance;

  // Future<firebase_storage.ListResult> listFiles() async {
  //   firebase_storage.ListResult results = await storage.ref("files").listAll();
  //   return results;
  // }
  FirebaseStorage storage = FirebaseStorage.instance; //create storage instance

  Future<String> uploadImage(String id, File file) async {
    var reference = storage
        .ref()
        .child("profileImages/$id"); //it will create folder for profileImages
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => null); //this will upload image
    String url = await taskSnapshot.ref
        .getDownloadURL(); // from there you will get image url.
    return url;
  }
}

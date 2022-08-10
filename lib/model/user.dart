import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String? email;
  final String? name;
  final String? phoneNumber;
  final String? imageUrl;

  UserModel({
    this.imageUrl,
    this.uid,
    this.phoneNumber,
    this.email,
    this.name,
  });

  factory UserModel.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      uid: snapshot["uid"],
      email: snapshot["email"],
      name: snapshot["name"],
      phoneNumber: snapshot["phoneNumber"],
      imageUrl: snapshot["imageUrl"] ?? "",
    );
  }

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      uid: map["uid"],
      email: map["email"],
      name: map["name"],
      phoneNumber: map["phoneNumber"],
      imageUrl: map["imageUrl"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "name": name,
        "phoneNumber": phoneNumber,
        "imageUrl": imageUrl ?? ""
      };
}

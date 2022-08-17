import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gtech/model/task.dart';
import 'package:gtech/utils/utils.dart';

class TaskService {
  final User? _auth = FirebaseAuth.instance.currentUser;
  DateTime time = DateTime.now();
  final path = FirebaseFirestore.instance
      .collection("tasks")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("user task");

  Future addTask(
      {required String title,
      required String content,
      required bool isComplete,
      required DateTime date}) async {
    try {
      await FirebaseFirestore.instance
          .collection("tasks")
          .doc(_auth!.uid)
          .collection("user task")
          .doc(time.toString())
          .set(
              TaskModel(
                      timeForUid: time.toString(),
                      title: title,
                      content: content,
                      isComplete: isComplete,
                      date: date)
                  .toJson(),
              SetOptions(merge: true));
      showToastMessage("success");
    } on Exception catch (e) {
      showToastMessage("error");
    }
  }

  Stream<QuerySnapshot> getUserTaskOnlyCompleted() {
    return path.where("isComplete", isEqualTo: true).snapshots();
  }

  Stream<QuerySnapshot> getUserTaskOnlyNotCompleted() {
    return path.where("isComplete", isEqualTo: false).snapshots();
  }

  Stream<QuerySnapshot> getUserTask() {
    return path.orderBy("date").snapshots();
  }

  Future getUserTaskFuture() async {
    await FirebaseFirestore.instance
        .collection("tasks")
        .doc(_auth!.uid)
        .collection("user task")
        .orderBy("date")
        .get();
  }

  Future deleteUserTask(String docId) async {
    try {
      await path.doc(docId).delete();
      showToastMessage("success");
    } on Exception {
      showToastMessage("error");
    }
  }

  Future completeTask(String docID, bool isComplete) async {
    try {
      await path.doc(docID).update({"isComplete": isComplete});
    } on Exception {
      showToastMessage("error");
    }
  }

  // Future<List<TaskModel>?> getUserTask() async {
  //   List<TaskModel>? result;
  //   QuerySnapshot<Map<String, dynamic>> value = await FirebaseFirestore.instance
  //       .collection("tasks")
  //       .doc("user task")
  //       .collection(_auth!.uid)
  //       .get();
  //   //print(value.docs);
  //   value.docs.forEach((element) {
  //     result?.add(TaskModel.fromSnap(element));
  //   });
  //   return result;
  // }
}

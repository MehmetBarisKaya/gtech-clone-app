import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String timeForUid;
  final String? title;
  final String? content;
  final bool? isComplete;
  final DateTime? date;

  TaskModel(
      {required this.timeForUid,
      this.title,
      this.isComplete,
      this.content,
      this.date});

  Map<String, dynamic> toJson() => {
        "timeForUid": timeForUid,
        "title": title,
        "content": content,
        "date": date,
        "isComplete": isComplete
      };

  factory TaskModel.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return TaskModel(
      timeForUid: snapshot["timeForUid"],
      title: snapshot["title"],
      content: snapshot["content"],
      date: snapshot["date"],
      isComplete: snapshot["isComplete"],
    );
  }
}

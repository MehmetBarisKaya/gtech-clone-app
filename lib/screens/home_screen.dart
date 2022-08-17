import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtech/model/user.dart';
import 'package:gtech/screens/task_description.dart';
import 'package:gtech/services/task_service.dart';
import 'package:gtech/utils/contants.dart';
import 'package:gtech/utils/utils.dart';
import 'package:gtech/widgets/custom_alertdialog.dart';
import 'package:intl/intl.dart';

import '../widgets/drawer.dart';
import '../widgets/user_task_bottom_sheet.dart';

enum FilterOptions { complete, notComplete, showAll }

class HomeScreen extends StatefulWidget {
  final UserModel userModel;
  const HomeScreen({required this.userModel, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  Stream<QuerySnapshot<Object?>> stream = TaskService().getUserTask();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Task"),
        actions: [
          PopupMenuButton(
            onSelected: (selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.complete) {
                  stream = TaskService().getUserTaskOnlyCompleted();
                } else if (selectedValue == FilterOptions.notComplete) {
                  stream = TaskService().getUserTaskOnlyNotCompleted();
                } else {
                  stream = TaskService().getUserTask();
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text("Complete"),
                value: FilterOptions.complete,
              ),
              const PopupMenuItem(
                child: Text("Not Complete"),
                value: FilterOptions.notComplete,
              ),
              const PopupMenuItem(
                child: Text("Show All!"),
                value: FilterOptions.showAll,
              ),
            ],
          ),
        ],
      ),
      drawer: NavigationDrawer(
        userData: widget.userModel,
      ),
      floatingActionButton: const FloatingActionButtonForTask(),
      body: Container(
        padding: kDefaultPadding,
        child: StreamBuilder<QuerySnapshot>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                final docs = snapshot.data?.docs;
                return ListView.builder(
                  itemCount: docs?.length,
                  itemBuilder: (context, index) {
                    var time = (docs?[index]['date'] as Timestamp).toDate();
                    var title = docs?[index]['title'];
                    var content = docs?[index]['content'];
                    var isComplete = docs?[index]["isComplete"];
                    var documentID = docs?[index]["timeForUid"];
                    return Dismissible(
                      key: UniqueKey(),
                      //movementDuration: Duration(seconds: 1),
                      background: buildSwipeActionLeft(),
                      secondaryBackground: buildSwipeActionRight(),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          try {
                            TaskService().completeTask(
                              documentID,
                              !isComplete,
                            );
                          } on Exception {
                            showSnackBar(context, "Something went wrong!");
                          }
                          return false;
                        } else if (direction == DismissDirection.endToStart) {
                          showAlertDialogWithTwoButton(
                              context: context,
                              titleText: "Please Confirm",
                              contentText: "Are you sure delete the task?",
                              noOnPressed: () {
                                Navigator.pop(context);
                              },
                              yesOnPressed: () {
                                try {
                                  TaskService().deleteUserTask(documentID);
                                  Navigator.pop(context);

                                  return true;
                                } on Exception {
                                  return false;
                                }
                              });
                        }
                        return null;
                      },
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaskDescription(
                                        title: title,
                                        description: content,
                                      )),
                            );
                          },
                          trailing: isComplete
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const Icon(Icons.check_circle),
                          leading: const Icon(Icons.assessment),
                          title: Text(title),
                          subtitle: Text(DateFormat.yMMMMEEEEd().format(time)),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Container();
              }
            }
          },
        ),
      ),
    );
  }

  Widget buildSwipeActionLeft() => Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.green,
        child: const Icon(Icons.archive_sharp, color: Colors.white, size: 32),
      );

  Widget buildSwipeActionRight() => Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete_forever, color: Colors.white, size: 32),
      );

  // selectPopupMenuItem() {
  //   return
  // }
}
//}

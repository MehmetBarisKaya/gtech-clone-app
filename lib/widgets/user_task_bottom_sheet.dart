import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gtech/services/task_service.dart';
import 'package:gtech/utils/utils.dart';
import 'package:gtech/widgets/custom_alertdialog.dart';
import 'package:intl/intl.dart';

import '../utils/contants.dart';

// Future<dynamic> userTaskBotoomSheet(BuildContext context) {
//   final _titleController = TextEditingController();
//   final _contentController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   bool isComplete = false;

//   return showModalBottomSheet(
//       context: context,
//       builder: (BuildContext ctx) {
//         return Padding(
//           padding: kDefaultPadding,
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   decoration: const InputDecoration(labelText: "Title"),
//                   controller: _titleController,
//                 ),
//                 SizedBox(
//                   height: 100,
//                   child: TextFormField(
//                     controller: _contentController,
//                     decoration: const InputDecoration(labelText: "Content"),
//                   ),
//                 ),
//                 ElevatedButton(
//                     onPressed: () {
//                       try {
//                         TaskService().addTask(_titleController.text.trim(),
//                             _contentController.text.trim(), isComplete);
//                         showToastMessage("Succesfull added!");
//                         showAlertDialog(
//                             context: context,
//                             titleText: "Succesfull",
//                             contentText: "yesp");
//                         Navigator.of(context).pop();
//                       } catch (e) {
//                         showToastMessage("Something went wrong!");
//                       }
//                     },
//                     child: const Text("Add"))
//               ],
//             ),
//           ),
//         );
//       });
// }
class FloatingActionButtonForTask extends StatefulWidget {
  const FloatingActionButtonForTask({Key? key}) : super(key: key);

  @override
  State<FloatingActionButtonForTask> createState() =>
      _FloatingActionButtonForTaskState();
}

class _FloatingActionButtonForTaskState
    extends State<FloatingActionButtonForTask> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isComplete = false;
  // DateTime? selectedDate;

  DateTime? _selectedDate;

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year + 1))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => Form(
              key: _formKey,
              child: SimpleDialog(
                contentPadding: kDefaultPadding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    const Text(
                      "Add Task",
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.grey,
                        size: 30,
                      ),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
                children: [
                  const Divider(),
                  TextFormField(
                    controller: _titleController,
                    //autofocus: true,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: TextFormField(
                      controller: _contentController,
                      //autofocus: true,
                      decoration: const InputDecoration(
                        labelText: "Content",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_selectedDate != null
                          ? DateFormat.yMd().format(_selectedDate!)
                          : "Select Date"),
                      ElevatedButton(
                          onPressed: _presentDatePicker,
                          child: const Text("date")),
                    ],
                  ),
                  SizedBox(
                    //width: width,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        child: const Text("Add"),
                        onPressed: () {
                          //print(DateFormat.yMd().format(_selectedDate!));
                          TaskService().addTask(
                              title: _titleController.text.trim(),
                              content: _contentController.text.trim(),
                              isComplete: isComplete,
                              date: _selectedDate!);

                          Navigator.of(context).pop();
                        }),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

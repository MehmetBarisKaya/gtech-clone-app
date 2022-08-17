import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

showToastMessage(String message) {
  return Fluttertoast.showToast(
    msg: message, // message
    toastLength: Toast.LENGTH_SHORT, // length
    //gravity: ToastGravity.CENTER, // location
    timeInSecForIosWeb: 2, // duration
  );
}

// DateTime _presentDatePicker(BuildContext context) {
//   showDatePicker(
//     context: context,
//     initialDate: DateTime.now(),
//     firstDate: DateTime(2021),
//     lastDate: DateTime.now(),

//   ).then((pickedDate) {
//     if (pickedDate == null) {
//       return;
//     } else {
//       return pickedDate;
//     }
//   });
// }
selectDate(BuildContext context) {
  final Future<DateTime?> picked = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101));
  return picked;
}

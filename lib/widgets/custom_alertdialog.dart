import 'package:flutter/material.dart';

showAlertDialog({
  required BuildContext context,
  String? titleText,
  String? contentText,
}) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      title: Text(titleText!),
      content: Text(contentText!),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: const Text("Ok"),
        ),
      ],
    ),
  );
}

showAlertDialogWithTwoButton({
  required BuildContext context,
  String? titleText,
  String? contentText,
  Function()? yesOnPressed,
  Function()? noOnPressed,
}) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(titleText!),
      content: Text(contentText!),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      actions: [
        ElevatedButton(child: const Text("Yes"), onPressed: yesOnPressed),
        ElevatedButton(child: const Text("No"), onPressed: noOnPressed),
      ],
    ),
  );
}

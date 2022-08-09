import 'package:flutter/material.dart';

class FormTextField extends StatefulWidget {
  const FormTextField({
    Key? key,
    required this.labelText,
    required this.icon,
    this.initialValues,
    this.keyboardType,
    this.controller,
    this.validator,
    this.onSaved,
    this.isObscure = false,
    this.suffixIcon,
  }) : super(key: key);
  final String? initialValues;
  final TextInputType? keyboardType;
  final bool isObscure;
  final String labelText;
  final Icon icon;
  final IconButton? suffixIcon;
  final TextEditingController? controller;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //autofillHints: const [AutofillHints.email],
      initialValue: widget.initialValues,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      onSaved: widget.onSaved,
      obscureText: widget.isObscure,
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon ??
            Container(
              //color: Colors.black,
              width: 10,
            ),
        prefixIcon: widget.icon,
        prefixIconColor: Colors.grey,
        labelText: widget.labelText,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 3, color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 5, color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

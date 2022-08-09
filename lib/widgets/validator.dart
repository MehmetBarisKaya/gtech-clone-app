class FormValidator {
  String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Please Enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid email';
      } else {
        return null;
      }
    }

    //return (value?.isNotEmpty ?? false) ? null : "Enter a valid email address";
  }

  String? validatePassword(String? value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value!.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  String? isEmpty(String? value) {
    if (value!.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  String? confirmPassword(String? value) {
    if (value!.isEmpty) {
      return "Pasword don't match";
    }
    return null;
  }
}

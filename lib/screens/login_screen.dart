import 'package:flutter/material.dart';
import 'package:gtech/screens/register_screen.dart';
import 'package:gtech/services/auth.dart';
import 'package:gtech/widgets/formtextfield.dart';
import 'package:gtech/widgets/validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool _isObscure = true;

  void _toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                      child:
                          Center(child: Image.asset("assets/images/logo.png")),
                    ),
                    mySizedBox(),
                    FormTextField(
                      labelText: 'Email',
                      icon: const Icon(Icons.mail),
                      controller: emailController,
                      onSaved: (value) {
                        setState(() {
                          print(value);
                        });
                      },
                      validator: FormValidator().validateEmail,
                    ),
                    mySizedBox(),
                    FormTextField(
                      isObscure: _isObscure,
                      labelText: 'Password',
                      icon: const Icon(Icons.key),
                      controller: passwordController,
                      suffixIcon: IconButton(
                        icon: _isObscure
                            ? const Icon(Icons.visibility_outlined)
                            : const Icon(Icons.visibility_off_outlined),
                        onPressed: () {
                          _toggleObscure();
                        },
                      ),
                      validator: FormValidator().validatePassword,
                    ),
                    mySizedBox(),
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          elevation: 20,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            AuthService().signIn(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                              context,
                            );
                          }
                        },
                        child: const Text("Login"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("If you have not account "),
                          GestureDetector(
                            child: const Text(
                              "Register!",
                              style: TextStyle(color: Colors.blue),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen()),
                              );
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox mySizedBox() {
    return const SizedBox(
      height: 10,
    );
  }
}

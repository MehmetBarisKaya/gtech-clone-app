import 'package:flutter/material.dart';
import 'package:gtech/provider/user_provider.dart';
import 'package:gtech/screens/home_screen.dart';
import 'package:gtech/screens/login_screen.dart';
import 'package:gtech/screens/main_screen.dart';
import 'package:gtech/services/auth.dart';
import 'package:provider/provider.dart';

import '../widgets/formtextfield.dart';
import '../widgets/validator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  bool _isObscure = true;

  void _toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  bool _paswordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<UserProvider>(context);
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: Center(
                            child: Image.asset("assets/images/logo.png")),
                      ),
                      mySizedBox(),
                      FormTextField(
                        labelText: 'Email',
                        icon: const Icon(Icons.mail),
                        controller: _emailController,
                        onSaved: (value) {
                          setState(() {
                            print(value);
                          });
                        },
                        validator: FormValidator().validateEmail,
                      ),
                      mySizedBox(),
                      FormTextField(
                        labelText: 'Name',
                        icon: const Icon(Icons.info_outline),
                        controller: _nameController,
                        onSaved: (value) {
                          setState(() {
                            print(value);
                          });
                        },
                        validator: FormValidator().isEmpty,
                      ),
                      mySizedBox(),
                      FormTextField(
                        labelText: 'Mobile Phone',
                        icon: const Icon(Icons.phone_callback_outlined),
                        controller: _phoneNumberController,
                        onSaved: (value) {
                          setState(() {
                            print(value);
                          });
                        },
                        validator: FormValidator().isEmpty,
                      ),
                      mySizedBox(),
                      FormTextField(
                        isObscure: _isObscure,
                        labelText: 'Password',
                        icon: const Icon(Icons.key),
                        controller: _passwordController,
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
                      FormTextField(
                        labelText: "Confirm Password",
                        isObscure: _isObscure,
                        icon: const Icon(Icons.person),
                        controller: _confirmPasswordController,
                        suffixIcon: IconButton(
                          icon: _isObscure
                              ? const Icon(Icons.visibility_outlined)
                              : const Icon(Icons.visibility_off_outlined),
                          onPressed: () {
                            _toggleObscure();
                          },
                        ),
                        validator: FormValidator().isEmpty,
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
                              if (_paswordConfirmed()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                // AuthService()
                                //     .register(
                                //         name: _nameController.text.trim(),
                                //         email: _emailController.text.trim(),
                                //         password:
                                //             _passwordController.text.trim(),
                                //         phoneNumber:
                                //             _phoneNumberController.text.trim(),
                                //         context: context)
                                try {
                                  authService.register(
                                      name: _nameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                      phoneNumber:
                                          _phoneNumberController.text.trim(),
                                      context: context);
                                  setState(() {
                                    _isLoading = false;
                                  });

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainScreen()),
                                  );
                                } on Exception catch (e) {
                                  print(e.toString());
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          },
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : const Text("Register"),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("If you have account "),
                            GestureDetector(
                              child: const Text(
                                "Login!",
                                style: TextStyle(color: Colors.blue),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MainScreen()),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
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

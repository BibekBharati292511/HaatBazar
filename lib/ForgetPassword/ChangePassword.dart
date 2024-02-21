import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hatbazarsample/main.dart';
import 'package:http/http.dart' as http;

import '../Utilities/ResponsiveDim.dart';
import '../Widgets/alertBoxWidget.dart';
import '../Widgets/loginBackgroundImage.dart';
import '../Widgets/progress_indicator.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _passwordVisible = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> changePasswords(String password) async {
    final url = Uri.parse("http://172.24.32.1:8080/user/changePassword");

    try {
      final response = await http.put(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, Object>{
          "email": userEmail!,
          "newPassword": password,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == 'Error') {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext dialogContext) {
              return MyAlertDialog(
                title: 'Error',
                content: responseData['message'],
              );
            },
          );
        }

        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return MyAlertDialog(
              title: 'Success',
              content: "Password changed successfully. Would you like to log in now?",
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'login');
                  },
                  child: Text('Log in'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(title: 'Error', content: 'Failed to change password: $e');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            LoginBackgroundImage(),
            Center(
              child: buildLoginContainer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoginContainer() {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.only(top: 160),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(42)),
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.white)),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: buildLoginForm(),
      ),
    );
  }

  Widget buildLoginForm() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context); // Navigate back
                  },
                ),
                Expanded(
                  child: Text(
                    'Change Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveDim.height20),
            ProgressIndicators(currentPage: 3, totalPages: 3),
            SizedBox(height: ResponsiveDim.height20),
            Text(
              'Enter new password for ',
              style: TextStyle(
                color: Colors.black,
                fontSize: ResponsiveDim.height20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$userEmail',
              style: TextStyle(
                color: Colors.blue,
                fontSize: ResponsiveDim.font24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            buildPasswordField('Create New password', passwordController),
            buildPasswordField('Confirm password', confirmPasswordController),
            buildSignInButton(),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String hintText,
      TextInputType keyboardType,
      TextEditingController controller,
      String? Function(String?)? validator,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 90.0, vertical: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: validator != null ? validator(controller.text) : null,
            fillColor: Colors.transparent,
            filled: true,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField(String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 90.0, vertical: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  hintText: hintText,
                  errorText: _validatePassword(controller.text),
                  fillColor: Colors.transparent,
                  filled: true,
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
              child: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 7) {
      return 'Password should be at least 7 characters';
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password should contain at least one uppercase letter';
    } else if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password should contain at least one lowercase letter';
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password should contain at least one number';
    }
    return null;
  }

  Widget buildSignInButton() {
    bool hasError =
        _validatePassword(passwordController.text) != null ||
            _validatePassword(confirmPasswordController.text) != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.07,
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
        child: ElevatedButton(
          onPressed: hasError ? null : () async {
            if (passwordController.text == confirmPasswordController.text) {
              String password = passwordController.text;
              await changePasswords(password);
            } else {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext dialogContext) {
                  return MyAlertDialog(title: 'Error', content: 'Passwords do not match');
                },
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF003F12),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          child: const Text(
            'Continue',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}

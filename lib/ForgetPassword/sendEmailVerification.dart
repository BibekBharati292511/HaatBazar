import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Utilities/ResponsiveDim.dart';
import '../Utilities/constant.dart';
import '../Widgets/alertBoxWidget.dart';
import '../Widgets/loginBackgroundImage.dart';
import '../Widgets/progress_indicator.dart';
import '../main.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> forgotPasswordScreens(String email) async {
    final url = Uri.parse("${serverBaseUrl}user/sendPassResetOtp");

    try {
      final response = await http.post(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, Object>{
          "email": email,
        }),
      );

      if (response.statusCode == 200) {
        // Decode the response JSON
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check if the response indicates that the user already exists
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
        } else {
          // Proceed to the verification page
          Navigator.pushNamed(context, 'verifyOtp');
        }
      } else {
        // Handle other status codes (e.g., 400, 500) here
        throw Exception('Failed to send verification code: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle network errors here
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(title: 'Error', content: 'Network Error: $e');
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
            const LoginBackgroundImage(),
            Center(
              child: buildLoginContainer(),
            ),
          ],
        ),
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
            const SizedBox(height: 12),
            AppBar(
              title: const Text('Forgot Password'),
            ),
            SizedBox(height:  ResponsiveDim.height20),
            const ProgressIndicators(currentPage: 1, totalPages: 3),
            const Text(
              "Please enter your email address you'd like your password reset info sent to",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 12),
            buildTextField(
              'Enter your email',
              TextInputType.emailAddress,
              emailController,
              _validateEmail,
            ),

            const SizedBox(height: 20),
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
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSignInButton() {
    bool hasError = _validateEmail(emailController.text) != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.07,
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
        child: ElevatedButton(
          onPressed: hasError
              ? null
              : () async {
            String email = emailController.text;
            userEmail = email;
            // Check if email is valid
            if (_validateEmail(email) == null) {
              // Proceed with user creation
              await forgotPasswordScreens(email);
              // Clear text fields
            } else {
              // Show error dialog for invalid email
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext dialogContext) {
                  return MyAlertDialog(
                      title: 'Error', content: _validateEmail(emailController.text)!);
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

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Enter valid email';
    }
    // Return null if email is valid
    return null;
  }
}


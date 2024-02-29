import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hatbazarsample/Widgets/progress_indicator.dart';
import 'package:hatbazarsample/main.dart';
import 'package:http/http.dart' as http;

import '../Utilities/ResponsiveDim.dart';
import '../Widgets/alertBoxWidget.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/loginBackgroundImage.dart';
import '../Widgets/login_container.dart';

class VerifyCustomerUser extends StatefulWidget {

  const VerifyCustomerUser({super.key});

  @override
  State<VerifyCustomerUser> createState() => _VerifyCustomerUserState();
}


class _VerifyCustomerUserState extends State<VerifyCustomerUser> {
  TextEditingController emailController= TextEditingController();
  TextEditingController otpController=TextEditingController();
  int currentPage = 3;
  int totalPages = 3;
  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    super.dispose();
  }

  Future<void> verifyUserAccounts(
      String otp, String email) async {
    final url = Uri.parse("http://172.24.32.1:8080/user/verify");

    try {
      final response = await http.post(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{
          "otp": otp,
          "email": email,
        }),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check if the response indicates that the user already exists
        if (responseData['status'] == 'Error') {
          if (!context.mounted) return;
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
        if (!context.mounted) return;
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return MyAlertDialog(
              title: 'Success',
              content: "Registered successfully. Would you like to log in now?",
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'login');
                  },
                  child: const Text('Log in'),
                ),
              ],
            );
          },
        );
      }
      else {
        // Handle other status codes (e.g., 400, 500) here
        throw Exception('Failed to create user: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle network errors here
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(title: 'Error', content: 'Failed to create user: $e');
        },
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            const LoginBackgroundImage(),
            Center(
              child: LoginContainer(
                children: <Widget>[
                  SizedBox(height: ResponsiveDim.height45,),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context); // Navigate back
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Verify email',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ResponsiveDim.font24,
                              fontWeight: FontWeight.bold,
                              fontFamily: "poppins"
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveDim.height20),
                  const ProgressIndicators(currentPage: 3, totalPages: 3),

                  SizedBox(height:  ResponsiveDim.height20,),
                  Text(

                    'Verification code send at',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ResponsiveDim.height20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   Text(
                    '$userEmail',
                    style:  TextStyle(
                      color: Colors.blue,
                      fontSize: ResponsiveDim.font24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: ResponsiveDim.height10,),
                  Padding(
                    padding: EdgeInsets.only(left: ResponsiveDim.height15),
                    child:  Text(
                      'Please check your email and enter the 6 digits number sent through your email to proceed',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ResponsiveDim.smallFont,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveDim.height20,),
                  Container(
                    width: ResponsiveDim.screenWidth / 2, // Half the size of the screen
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: otpController,
                      decoration: const InputDecoration(
                        labelText: 'Enter OTP', // Label//
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                  SizedBox(height: ResponsiveDim.height15,),
                  buildSignInButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSignInButton() {
    return CustomButton(
      buttonText: 'Sign Up',
      onPressed: () async {
        String otp=otpController.text;
        await verifyUserAccounts(otp,userEmail!);
        otpController.clear();
      },
    );
  }

}


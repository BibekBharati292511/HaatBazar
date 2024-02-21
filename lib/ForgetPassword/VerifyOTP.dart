import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/SignUp/create_customer_account.dart';
import 'package:hatbazarsample/Widgets/progress_indicator.dart';
import 'package:hatbazarsample/main.dart';
import 'package:http/http.dart' as http;

import '../Utilities/ResponsiveDim.dart';
import '../Widgets/alertBoxWidget.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/loginBackgroundImage.dart';
import '../Widgets/login_container.dart';
import '../Widgets/radio_box.dart';

class VerifyOtp extends StatefulWidget {

  const VerifyOtp({Key? key}) : super(key: key);

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}


class _VerifyOtpState extends State<VerifyOtp> {
  TextEditingController emailController= TextEditingController();
  TextEditingController otpController=TextEditingController();
  int currentPage = 2;
  int totalPages = 3;
  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    super.dispose();
  }

  Future<void> verifyUserAccounts(
      String otp, String email) async {
    final url = Uri.parse("http://172.24.32.1:8080/user/verifyResetOtp");

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
          Navigator.pushNamed(context, 'changePassword');
        }
      }
      else {
        // Handle other status codes (e.g., 400, 500) here
        throw Exception('Failed to verify otp: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle network errors here
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(title: 'Error', content: 'Failed to verify otp: $e');
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
            LoginBackgroundImage(),
            Center(
              child: LoginContainer(
                children: <Widget>[
                  SizedBox(height: ResponsiveDim.height45,),
                  Center(
                    child: AppBar(title: Text("Verify Otp"),),
                  ),
                  SizedBox(height:  ResponsiveDim.height20),
                  ProgressIndicators(currentPage: 2, totalPages: 3),

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
                      decoration: InputDecoration(
                        labelText: 'Enter OTP', // Label//
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                      style: TextStyle(color: Colors.blue),
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
      buttonText: 'Continue',
      onPressed: () async {
        String otp=otpController.text;
        await verifyUserAccounts(otp,userEmail!);
        otpController.clear();
      },
    );
  }

}


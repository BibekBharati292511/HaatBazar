import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';
import 'package:hatbazarsample/main.dart';

import '../Model/ProfileCompletionTracker.dart';
import '../Model/UserData.dart';
import '../Utilities/ResponsiveDim.dart';
import '../Utilities/constant.dart';
import '../Widgets/alertBoxWidget.dart';
import '../Widgets/loginBackgroundImage.dart';
import '../Widgets/login_container.dart';
import '../Widgets/progress_indicator.dart';
import 'package:http/http.dart' as http;

class VerifyPhoneNumber extends StatefulWidget {
  const VerifyPhoneNumber({super.key});

  @override
  State<VerifyPhoneNumber> createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  TextEditingController otpController =TextEditingController();
  Future<void> setPhoneNumber(String otp) async {
    final url = Uri.parse("${serverBaseUrl}user/verifyNumberOtp");
    try {
      final response = await http.post(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, Object>{
          "number":number!,
          "otp":otp,
          "email": userEmail!,
        }),
      );
      if (!context.mounted) return;
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData);

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
        else{
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return MyAlertDialog(
              title: 'Success',
              content: "Number set successfully.",
              actions: [
                TextButton(
                  onPressed: () async {
                    await ProfileCompletionTracker.profileCompletionTracker();
                    await UserDataService.fetchUserData(userToken!).then((
                        userData) {
                      userDataJson = jsonDecode(userData);
                    });
                    Navigator.pushNamed(context, 'sellerHomePage');
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      }
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(title: 'Error', content: 'Failed to set Number: $e');
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
                  SizedBox(height: ResponsiveDim.height20,),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Navigate to the previous page
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                    ],
                  ),
                  Center(
                    child:  Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ResponsiveDim.font24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height:  ResponsiveDim.height20),
                  const ProgressIndicators(currentPage: 2, totalPages: 2),
                  SizedBox(height:  ResponsiveDim.height20,),
                  Text(
                    "Verify Phone Number",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ResponsiveDim.bigFont,
                      fontWeight: FontWeight.bold,
                      fontFamily: "poppins",
                    ),
                  ),
                  SizedBox(height: ResponsiveDim.radius6,),
                  Padding(
                    padding:  EdgeInsets.only(left: ResponsiveDim.width45,right: ResponsiveDim.width30),
                    child: Text(
                      "Please enter the 6-digit code sent to:",
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: ResponsiveDim.smallFont,
                        fontWeight: FontWeight.normal,
                        fontFamily: "poppins",
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveDim.radius6,),
                  Text(
                    "$number",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: ResponsiveDim.height20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "poppins",
                    ),
                  ),
                   Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveDim.width45, vertical: ResponsiveDim.height15),
                    child: TextField(
                      controller: otpController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(ResponsiveDim.radius30)
                        ),
                        hintText: 'Otp',
                      ),
                    ),
                  ),
                  CustomButton(
                    buttonText: "Continue",
                    onPressed: ()
                      async {
                      print(userEmail);
                      print(number);
                        String otp = otpController.text;
                        print(otp);
                        await setPhoneNumber(otp);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

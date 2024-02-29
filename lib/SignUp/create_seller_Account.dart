import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';
import 'package:hatbazarsample/main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../Utilities/ResponsiveDim.dart';
import '../Utilities/constant.dart';
import '../Widgets/alertBoxWidget.dart';
import '../Widgets/loginBackgroundImage.dart';
import '../Widgets/login_container.dart';
import '../Widgets/progress_indicator.dart';
import 'package:http/http.dart' as http;

class CreateSellerAccount extends StatefulWidget {
  const CreateSellerAccount({super.key});

  @override
  State<CreateSellerAccount> createState() => _CreateSellerAccountState();
}
class _CreateSellerAccountState extends State<CreateSellerAccount> {
  late String phoneNumber;
  bool phoneNumberValid = true;

  Future<void> sendNumberOtp(String toNumber) async {
    final url = Uri.parse("${serverBaseUrl}user/sendSms");

    try {
      final response = await http.post(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, Object>{
          "to": toNumber,
        }),
      );

      if (response.statusCode == 200) {
        if (!context.mounted) return;
        // Proceed to the verification page
        Navigator.pushNamed(context, 'verifyPhoneNumber');
      } else {
        print(response.reasonPhrase);
        // Handle other status codes (e.g., 400, 500) here
        String errorMessage = response.reasonPhrase ?? 'Unknown error';
        if (response.body.isNotEmpty) {
          try {
            Map<String, dynamic> responseData = jsonDecode(response.body);
            errorMessage = responseData['message'] ?? errorMessage;
          } catch (e) {
            print('Error decoding error response: $e');
          }
        }
        throw Exception('Failed to send otp: $errorMessage');
      }
    } catch (e) {
      // Handle network errors here
      print(e);
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(title: 'Error', content: 'Failed to send Otp: $e');
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
                      'Set Phone Number',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ResponsiveDim.font24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height:  ResponsiveDim.height20),
                  const ProgressIndicators(currentPage: 1, totalPages: 2),
                  SizedBox(height:  ResponsiveDim.height20,),
                  Text(
                    "What's your mobile Number?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ResponsiveDim.bigFont,
                      fontWeight: FontWeight.bold,
                      fontFamily: "poppins",
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: ResponsiveDim.width20),
                    child: Text(
                      "A mobile number is helpful when buyers wants to contact you",
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: ResponsiveDim.smallFont,
                        fontWeight: FontWeight.normal,
                        fontFamily: "poppins",
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: ResponsiveDim.width45, top: ResponsiveDim.height45,right: ResponsiveDim.width45),

                        child: IntlPhoneField(
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderRadius:BorderRadius.circular(ResponsiveDim.radius30),
                              borderSide: BorderSide(color: phoneNumberValid ? Colors.grey : Colors.redAccent),
                            ),
                          ),

                          initialCountryCode: 'NP',
                          onChanged: (phone) {
                            setState(() {
                              phoneNumber = phone.completeNumber;
                              phoneNumberValid = true;
                            });
                          },
                        ),
                      ),
                      if (!phoneNumberValid)
                        Padding(
                          padding:  EdgeInsets.only(left: ResponsiveDim.width45),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Enter mobile number",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: ResponsiveDim.height20,),
                  CustomButton(
                    buttonText: "continue",
                    onPressed: () async{
                      if (phoneNumber.isEmpty) {
                        setState(() {
                          phoneNumberValid = false;
                        });
                      } else {
                        String toNumber=phoneNumber;
                        print(toNumber);
                        await sendNumberOtp(toNumber);
                        print("Number is $phoneNumber");
                        number=phoneNumber;
                      }
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


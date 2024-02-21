import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';
import 'package:hatbazarsample/main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../Utilities/ResponsiveDim.dart';
import '../Widgets/loginBackgroundImage.dart';
import '../Widgets/login_container.dart';
import '../Widgets/progress_indicator.dart';

class VerifyPhoneNumber extends StatefulWidget {
  const VerifyPhoneNumber({Key? key}) : super(key: key);

  @override
  State<VerifyPhoneNumber> createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {

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
                  SizedBox(height: ResponsiveDim.height20,),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Navigate to the previous page
                        },
                        child: Icon(Icons.arrow_back),
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
                  ProgressIndicators(currentPage: 2, totalPages: 2),
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
                    onPressed: () {

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

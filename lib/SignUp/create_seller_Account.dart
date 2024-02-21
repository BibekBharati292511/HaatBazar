import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';
import 'package:hatbazarsample/main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../Utilities/ResponsiveDim.dart';
import '../Widgets/loginBackgroundImage.dart';
import '../Widgets/login_container.dart';
import '../Widgets/progress_indicator.dart';

class CreateSellerAccount extends StatefulWidget {
  const CreateSellerAccount({Key? key}) : super(key: key);

  @override
  State<CreateSellerAccount> createState() => _CreateSellerAccountState();
}

class _CreateSellerAccountState extends State<CreateSellerAccount> {
  String? phoneNumber;
  bool phoneNumberValid = true;

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
                  ProgressIndicators(currentPage: 1, totalPages: 2),
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
                  Text(
                    "A mobile number is required for signup.",
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: ResponsiveDim.smallFont,
                      fontWeight: FontWeight.normal,
                      fontFamily: "poppins",
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
                    onPressed: () {
                      if (phoneNumber == null || phoneNumber!.isEmpty) {
                        setState(() {
                          phoneNumberValid = false;
                        });
                      } else {
                        Navigator.pushNamed(context, 'verifyPhoneNumber');
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

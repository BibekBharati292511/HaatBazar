

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hatbazarsample/ForgetPassword/ChangePassword.dart';
import 'package:hatbazarsample/ForgetPassword/VerifyOTP.dart';
import 'package:hatbazarsample/SellerCenter/HomePage/SellerHomePageMain.dart';
import 'package:hatbazarsample/SignUp/role_selection.dart';
import 'package:hatbazarsample/SignUp/verify_customer_user.dart';
import 'package:hatbazarsample/SignUp/verify_phone_number.dart';
import 'package:hatbazarsample/login.dart';
import 'package:hatbazarsample/HomePage/main_product_page.dart';

import 'package:hatbazarsample/createAccount.dart';

import 'ForgetPassword/sendEmailVerification.dart';
import 'SignUp/create_customer_account.dart';
import 'SignUp/create_seller_Account.dart';
String? userEmail;
String? number;
int? roleId;

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    routes: {
      'login': (context) => const MyLogin(),
      'createUserAccount': (context) => const CreateUserAccount(),
      'homePage':(context) => const MainProductPage(),
      'roleSelection':(context)=> const RoleSelection(),
      'verifyCustomerUser':(context)=>const VerifyCustomerUser(),
      'verifyOtp':(context)=>const VerifyOtp(),
      'changePassword':(context)=>const ChangePassword(),
      'createSellerAccount':(context)=>const CreateSellerAccount(),
      'verifyPhoneNumber':(context)=>const VerifyPhoneNumber(),
      'sendEmailVerification':(context)=>ForgotPasswordScreen(),

      //Seller Center
      'sellerHomePage':(context)=>SellerCenterMain(),

    },
  ));
}




import 'dart:typed_data';

import 'package:address_search_field/address_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hatbazarsample/ForgetPassword/ChangePassword.dart';
import 'package:hatbazarsample/ForgetPassword/VerifyOTP.dart';
import 'package:hatbazarsample/SellerCenter/HomePage/SellerHomePageMain.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/AddAddress/add_address.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/AddAddress/location_controller.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/AddAddress/map_screen.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/AddStore/add_store.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/CompleteProfile/complete_profile_main.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/CompleteProfile/edit_name.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/CompleteProfile/edit_profile_image.dart';
import 'package:hatbazarsample/SignUp/role_selection.dart';
import 'package:hatbazarsample/SignUp/verify_customer_user.dart';
import 'package:hatbazarsample/SignUp/verify_phone_number.dart';
import 'package:hatbazarsample/login.dart';
import 'package:hatbazarsample/HomePage/main_product_page.dart';


import 'ForgetPassword/sendEmailVerification.dart';
import 'SignUp/create_customer_account.dart';
import 'SignUp/create_seller_Account.dart';
String? userEmail;
String? number;
String? storeNumber;
String? userToken;
int? roleId;
late Map<String, dynamic> userDataJson;
late Map<String, dynamic> userAddressJson;
late Map<String, dynamic> userAddress;
Uint8List? bytes;
bool isProfileCompleted = false;
bool isAddAddressCompleted=false;
bool isAddStoreCompleted=false;
bool isAddBankAccountCompleted=false;
bool isAddProductCompleted=false;
bool fromUser=true;
bool fromStore=true;


Future<void> main() async {
  Get.put(LocationController());
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
      'sendEmailVerification':(context)=>const ForgotPasswordScreen(),

      //Seller Center
      'sellerHomePage':(context)=>const SellerCenterMain(),

      //to do list seller
      'completeProfile':(context)=>const CompleteProfileMainSeller(),
      'editName':(context)=>const EditName(),
      'editProfileImage':(context)=>const ImageUpload(),
      'addAddress':(context)=>const AddAddressPage(),
      'mapScreen':(context)=>const MapScreen(),
      'addStore':(context)=>const AddStorePage(),

    },
  ));
}


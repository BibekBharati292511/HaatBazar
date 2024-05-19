
import 'dart:io';
import 'dart:typed_data';

import 'package:address_search_field/address_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hatbazarsample/AgroTechnicians/profile.dart';
import 'package:hatbazarsample/AgroTechnicians/technician_landing_page.dart';
import 'package:hatbazarsample/AgroTechnicians/home.dart';
import 'package:hatbazarsample/AgroTechnicians/to_do_list_technician.dart';
import 'package:hatbazarsample/CheckOut/check_out.dart';
import 'package:hatbazarsample/ForgetPassword/ChangePassword.dart';
import 'package:hatbazarsample/ForgetPassword/VerifyOTP.dart';
import 'package:hatbazarsample/SellerCenter/HomePage/SellerHomePageMain.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/AddAddress/add_address.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/AddAddress/location_controller.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/AddAddress/map_screen.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/AddProduct/add_product.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/AddProduct/add_product2.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/AddProduct/preview_and_confirmation.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/AddAddress/viewAddress.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/AddStore/AddressMapScreen.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/AddStore/add_store_main.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/AddStore/delivery_options.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/CompleteProfile/complete_profile_main.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/CompleteProfile/edit_name.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/CompleteProfile/edit_profile_image.dart';
import 'package:hatbazarsample/SignUp/role_selection.dart';
import 'package:hatbazarsample/SignUp/verify_customer_user.dart';
import 'package:hatbazarsample/SignUp/verify_phone_number.dart';
import 'package:hatbazarsample/login.dart';
import 'package:hatbazarsample/HomePage/main_product_page.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:permission_handler/permission_handler.dart';


import 'AddToCart/add_to_cart_page.dart';
import 'AddToCart/cart_controller.dart';
import 'ForgetPassword/sendEmailVerification.dart';
import 'Notification/push_notification_trial.dart';
import 'ProductCard/product.dart';
import 'SellerCenter/Product Detail/product_detail_home.dart';
import 'SellerCenter/ToDOList/AddStore/create_store.dart';
import 'SellerCenter/ToDOList/AddStore/payment_options.dart';
import 'SellerCenter/ToDOList/AddStore/store_profile.dart';
import 'SellerCenter/ToDOList/AddStore/store_type.dart';
import 'SignUp/create_customer_account.dart';
import 'SignUp/create_seller_Account.dart';

String? userEmail;
String? number;
String? storeNumber;
String? userToken;
String? role;
int? roleId;
int? storeTypeId;
int? storeId;
late Map<String, dynamic> userDataJson;
late Map<String, dynamic> userAddressJson;
late Map<String, dynamic> userAddress;
late List<dynamic> storeDataJson;
late Map<String, dynamic> storeAddressJson;
late Map<String,dynamic>storeAddress;
Uint8List? bytes;
bool isProfileCompleted = false;
bool isAddAddressCompleted=false;
bool isAddStoreCompleted=false;
bool isAddBankAccountCompleted=false;
bool isAddProductCompleted=false;
bool fromUser=true;
bool fromStore=false;
late String token;
late String phone;
late String name;
int notificationCount=0;
bool fromViewer=false;

// store profile tracker
bool isAddStoreImageCompleted=false;
bool isStoreProfileCompleted=false;
bool isStoreAddressCompleted=false;
bool isStoreDeliveryOptionCompleted=false;
bool isStorePaymentOptionCompleted=false;
bool isAddStoreNumberCompleted=false;
addStoreStatsChecker(){
  if(isAddStoreImageCompleted &&
      isStoreProfileCompleted &&
      isStoreAddressCompleted &&
      isStoreDeliveryOptionCompleted &&
      isStorePaymentOptionCompleted &&
      isAddStoreNumberCompleted){
    return isAddStoreCompleted=true;
  }
}

//product fields
int? categoryID;
int? subCategoryID;
String? productNameEnglish;
String? productNameNepali;
late String productHighlights;
late String productDescription;
late String productRate;
late String availabilityInfo;
late String availableDate;
double? availableQty;
late String qtyUnit;
late String harvestedSeason;
List<File> imageFiles = [];
List<Uint8List> imageBytes = [];
List<Uint8List> imageBytesList = [];
List<Uint8List> imageBytesListByProductFromDb=[];
late String priceUnit;
List<String> images = [];

Map<int, String> idToProductName = {};
Map<String, int> productNameToId = {};
//product
List<List<Product>> productLists = [];
List<List<Product>> recommendedProductLists=[];
List<List<Product>> freeDeliveryProductLists=[];
List<List<Product>> nearMeProductLists=[];
bool filtered=false;
var cartItemCount;
List<String> productNames = [];
Set<String> uniqueOrderIds = {};
bool isFetchByNameCompleted=false;
bool fromTech=false;
bool technicianBookingReqSent=false;
bool paymentTracker=false;

//technician tracker
bool isAddSettingsCompleted=false;
bool isTechnicianSetupCompleted=false;
addTechnicianStatsChecker(){
  if(isAddSettingsCompleted &&
      isProfileCompleted &&
      isAddAddressCompleted){
    return isTechnicianSetupCompleted=true;
  }
}

bool isUploadingToCloudinary=false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await  LocalNotifications.init();
  requestPermissions();
  Get.put(LocationController());
  runApp( KhaltiScope(
      publicKey: "test_public_key_3fc977f795ac4d918866ca2001d44d59",
      enabledDebugging: true,
      builder: (context, navKey) {

    return GetMaterialApp(
      navigatorKey: navKey,
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      localizationsDelegates: const [KhaltiLocalizations.delegate],
      routes: {
      'technicianProfile':(context)=>const ProfileTechnician(),
      'toDoTechnician':(context)=>const ToDoListTechnician(),
      'technicianHome':(context)=> const TechnicianLandingPage(),
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
      //'productHome':(context)=>const ProductDetail(),

      //to do list seller
      'completeProfile':(context)=>const CompleteProfileMainSeller(),
      'editName':(context)=>const EditName(),
      'editProfileImage':(context)=>const ImageUpload(),
      'addAddress':(context)=>const AddAddressPage(),
      'mapScreen':(context)=>const MapScreen(),
      'addStore':(context)=>const AddStorePage(),
      'addProduct':(context)=> AddProductPage(),
      'addProduct2':(context)=> AddProductPage2(),
      'productConfirmation':(context)=>PreviewAndConfirmation(),

      //add store route
      'StoreProfile':(context)=>const StoreProfilePage(),
      'storeType':(context)=> const StoreTypePage(),
      'createStore':(context)=>const CreateStore(),
      'storeAddress':(context)=>const StoreMapScreen(),
      'storeDeliveryOptions':(context)=>const storeDeliveryOptions(),
      'storePaymentOptions':(context)=>const storePaymentOptions(),

      //view address
      'viewAddress':(context)=>ViewAddressPage(latitude: storeAddress['latitude'], longitude: storeAddress['longitude']),

      //add to cart
      'toCart':(context)=>AddToCartPage(),
      'checkout':(context)=>CheckOutPage(),
    },
  );}));


}
Future<void> requestPermissions() async {
  // Request location permission
  if (await Permission.location
      .request()
      .isDenied) {

  }

  if(await Permission.notification.request().isDenied){
  }
  // Request storage permission
  if (await Permission.storage
      .request()
      .isDenied) {
    //an show a dialog or toast here to inform the user about the importance of storage permission.
  }
}

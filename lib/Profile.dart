import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:hatbazarsample/main.dart';
import 'package:http/http.dart' as http;

import 'Utilities/ResponsiveDim.dart';
import 'Utilities/colors.dart';
import 'Widgets/bigText.dart';
import 'Widgets/custom_button.dart';
import 'Widgets/profile_image_widget.dart';

class ProfileSeller extends StatefulWidget {
  const ProfileSeller({Key? key}) : super(key: key);

  @override
  State<ProfileSeller> createState() => _ProfileSellerState();
}

class _ProfileSellerState extends State<ProfileSeller> {
  late Future<List<String>> _deliveryOptionsFuture;
  late Future<List<String>> _paymentOptionsFuture;

  @override
  void initState() {
    super.initState();
    _deliveryOptionsFuture = fetchDeliveryOptions();
    _paymentOptionsFuture = fetchPaymentOptions();
  }

  Future<List<String>> fetchDeliveryOptions() async {
    final response = await http.get(Uri.parse('${serverBaseUrl}storeDeliveryOptions/DeliveryOptionsByStored?store_id=$storeId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((option) => option['deliveryOptions'].toString()).toList();
    } else {
      throw Exception('Failed to load delivery options');
    }
  }

  Future<List<String>> fetchPaymentOptions() async {
    final response = await http.get(Uri.parse('${serverBaseUrl}storePaymentOptions/getPaymentOptionsByStoreId?store_id=$storeId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((option) => option['paymentOptions'].toString()).toList();
    } else {
      throw Exception('Failed to load delivery options');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BigText(text: "Profile",color: Colors.white,),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Your existing profile information here
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ProfileImage(bytes:bytes,width: 250,height: 250,),
                                  SizedBox(width: ResponsiveDim.width15,),
                                  Text("    ",),
                                  // Icon(Icons.edit,color: Colors.red,)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BigText(text: '${userDataJson["firstName"]} ${userDataJson["lastName"]} ',weight: FontWeight.bold,),
                                  SizedBox(width: ResponsiveDim.width15,),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pushNamed(context,'completeProfile');
                                    },
                                    child: Icon(Icons.edit,color: Colors.red,),
                                  )
                                ],
                              ),
                              SizedBox(height: ResponsiveDim.height5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BigText(text: '${userDataJson["phone_number"]}'),
                                  SizedBox(width: ResponsiveDim.width15,),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pushNamed(context, "createSellerAccount");
                                    },
                                    child: Icon(Icons.edit,color: Colors.red,),
                                  )
                                ],
                              ),
                              BigText(text: '${userDataJson["email"]}  ',size: ResponsiveDim.smallFont,),
                              SizedBox(height: ResponsiveDim.height5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${userAddress['cityDistrict']} ${userAddress['state']} ${userAddress['county']}'),
                                  SizedBox(width: ResponsiveDim.width10,),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pushNamed(context, 'mapScreen');
                                    },
                                    child: Icon(Icons.my_location,color: Colors.red,),
                                  )
                                ],
                              ),
                              SizedBox(height: ResponsiveDim.height15),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Delivery Options Section
                  FutureBuilder<List<String>>(
                    future: _deliveryOptionsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final List<String> deliveryOptions = snapshot.data ?? [];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7.0),
                              child:  Row(
                                children: [
                                  BigText(text: "My Delivery Options"),
                                  SizedBox(width: ResponsiveDim.width30,),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pushNamed(context, 'storeDeliveryOptions');
                                    },
                                    child: Icon(Icons.add_circle, color: Colors.red, size: 30,),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: deliveryOptions.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(deliveryOptions[index]),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  FutureBuilder<List<String>>(
                    future: _paymentOptionsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final List<String> paymentOptions = snapshot.data ?? [];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7.0),
                              child:   Row(
                                children: [
                                  BigText(text: "My Payment Options"),
                                  SizedBox(width: ResponsiveDim.width30,),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pushNamed(context, 'storePaymentOptions');
                                    },
                                    child: Icon(Icons.add_circle, color: Colors.red, size: 30,),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: paymentOptions.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal:5, vertical: 0),
                                    title: Text(paymentOptions[index]),
                                  );
                                },
                              ),
                            ),
                            CustomButton(color:Colors.red,buttonText: "Logout", onPressed: (){
                             _logout(context);
                            },width: ResponsiveDim.screenWidth,),
                            SizedBox(height: ResponsiveDim.height15,)
                          ],
                        );
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
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushNamed(context, 'login'); // Logout
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}

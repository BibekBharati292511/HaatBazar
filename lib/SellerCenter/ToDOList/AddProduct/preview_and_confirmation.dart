import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/AddProduct/add_product.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';
import 'package:hatbazarsample/Widgets/smallText.dart';

import '../../../ProductCard/ProductOverview.dart';
import '../../../ProductCard/bigProductCardWidget.dart';
import '../../../Services/get_product_by_storeID.dart';
import '../../../Services/image_uploader_service.dart';
import '../../../Utilities/colors.dart';
import '../../../Utilities/constant.dart';
import '../../../Widgets/alertBoxWidget.dart';
import '../../../main.dart';
import 'package:http/http.dart' as http;

class PreviewAndConfirmation extends StatefulWidget {

  const PreviewAndConfirmation({super.key});

  @override
  State<PreviewAndConfirmation> createState() => _PreviewAndConfirmationState();
}

class _PreviewAndConfirmationState extends State<PreviewAndConfirmation> {
  bool _isLoading = false;
  Future<void> handleImageUpload(List<Uint8List> imageBytesList, String productName, BuildContext context) async {
    try {
      var response = await uploadImageService(imageBytesList, productName);
      if (response.statusCode == 200) {
        // Image upload successful
        print('Images uploaded successfully');
      } else {
        // Image upload failed
        print('Failed to upload images: ${response.body}');
        // Handle the failure accordingly, e.g., show an error message
      }
    } catch (e) {
      // Error occurred while uploading images
      print('Error uploading imageassssss: $e');
      // Handle the error accordingly, e.g., show an error message
    }
  }
  Future<void> addProduct() async {
    final url = Uri.parse("${serverBaseUrl}products/add");

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, Object>{
          "storeId":storeId??"",
          "name": productNameEnglish??'',
          "nameNepali": productNameNepali??"",
          "price": productRate,
          "description": productDescription??'',
          "highlights": productHighlights??'',
          "category": {"id": categoryID},
          "subCategory": {"id": subCategoryID},
          "harvestedSeason": harvestedSeason,
          "availableQty": availableQty??'',
          "qtyUnit": qtyUnit,
          "availableTill": availableDate,
          "priceUnit": priceUnit,
        }),
      );

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (responseBody["success"] == true) {
        await handleImageUpload(imageBytesList, productNameEnglish!, context);
        if (!context.mounted) return;
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return MyAlertDialog(
              title: 'Success',
              content: 'product added successfully',
              actions: [
                TextButton(
                  onPressed: () async {
                    await fetchProductByStoreId(storeId!);
                   // Navigator.pop(context);
                    Navigator.pushNamed(context, 'sellerHomePage');
                    },
                  child: const Text('Ok'),
                ),
              ],);
          },
        );

      } else {
        if (!context.mounted) return;
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return MyAlertDialog(
              title: 'Error',
              content: 'Failed to add product right now: ${responseBody["message"]}',
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      }
    } on SocketException catch(e) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(title: 'Error', content: 'Network not available: $e');
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    print(storeDataJson);
    print(imageBytesList);
    print(storeDataJson[0]["name"]);
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              title: Text("Preview and Confirmation",style: TextStyle(color: Colors.white),),
              backgroundColor: AppColors.primaryColor,
            ),
            Expanded( // Add Expanded widget here
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BigText(text: ' product overview', weight: FontWeight.bold),
                      const Text(
                        "Check the overall overview of your product before confirming",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: 'poppins',
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      ProductOverviewWidget(
                        productName: productNameEnglish,
                        description: productDescription,
                        price: productRate,
                        rating: 4.5,
                        reviewCount: 32,
                        producer: storeDataJson[0]["name"],
                        imageBytesList: imageBytesList,
                        highlights: productHighlights,
                        availableDate: availableDate,
                        availableQty: availableQty,
                        harvestedSeason: harvestedSeason,
                      ),
                      CustomButton(buttonText: 'Confirm and submit' ,onPressed: () async {
                        await addProduct();


                      })

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}

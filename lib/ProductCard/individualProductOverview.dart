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

import '../../ProductCard/ProductOverview.dart';
import '../../ProductCard/bigProductCardWidget.dart';
import '../../Services/get_product_by_storeID.dart';
import '../../Services/image_uploader_service.dart';
import '../../Utilities/colors.dart';
import '../../Utilities/constant.dart';
import '../../Widgets/alertBoxWidget.dart';
import '../../main.dart';
import 'package:http/http.dart' as http;

import '../Model/UserData.dart';
import '../Services/get_imageBy_product_name.dart';
import '../main.dart' as main;


class IndividualProductOverview extends StatefulWidget {
  final String productName;

  const IndividualProductOverview({super.key,required this.productName});
  @override
  State<IndividualProductOverview> createState() => _IndividualProductOverviewState();
}
Future<void>  fetchProductByName(String name) async {
  final url = Uri.parse('${serverBaseUrl}products/name?productName=$name');


  final response = await http.get(url);

  if (response.statusCode == 200) {
    Map<String,dynamic> jsonResponse = jsonDecode(response.body);
    //productId=jsonResponse[0]["id"];
    // final url = Uri.parse('${serverBaseUrl}products/store?storeId=$productId');
    print(jsonResponse);
    print(jsonResponse["name"]);
    main.storeId =jsonResponse["storeId"] as int;
    print("store id from id oroduct name is $storeId");
    productNameEnglish=jsonResponse['name'] as String;
    productRate=jsonResponse['price'].toString();
    productHighlights=jsonResponse['highlights'] as String;
    productDescription=jsonResponse['description'] as String;
    main.harvestedSeason= jsonResponse['harvestedSeason'] as String ;
    main.availableQty= jsonResponse['availableQty'] as double;
    main.qtyUnit= jsonResponse['qtyUnit'] as String;
    main.availableDate= DateTime.parse(jsonResponse['availableTill'] as String).toString();
    main.priceUnit= jsonResponse['priceUnit'] as String;
    await UserDataService.fetchStoreDataById(storeId!).then((storeData) {
      storeDataJson = jsonDecode(storeData);
    });


  }
  else {
    throw Exception('Failed to load products. Status code: ${response.statusCode}');
  }
}

class _IndividualProductOverviewState extends State<IndividualProductOverview> {
 late String  name;
  bool _isLoading = true;
  List<String> productImages = []; // Change back to List<String>

 @override
 void initState() {
   super.initState();
   fetchProductImages();
   name = widget.productName;
   fetchProductByName(widget.productName).then((_) {
     setState(() {
       _isLoading = false;
     });
   }).catchError((error) {
     print('Error: $error');
     setState(() {
       _isLoading = false;
     });
   });
 }
  Uint8List decodeBase64ToUint8List(String base64String) {
    String base64Data = base64String.split(',').last;
    return base64.decode(base64Data);
  }

// Your fetchProductImages function
  Future<void> fetchProductImages() async {
    imageBytesList=[];
    try {
      final images = await ImageFetcherService.fetchProductImages(widget.productName);
      // Decode each base64 string and add it to the imageBytesList
      for (var base64Image in images) {
        Uint8List imageBytes = decodeBase64ToUint8List(base64Image);
        imageBytesList.add(imageBytes);
      }

      setState(() {});
    } catch (e) {
      print('Error fetching product images: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    print(widget.productName);
    //fetchProductByStoreId(storeId);
    return Scaffold(
      body:  _isLoading
          ? Center(
        child: CircularProgressIndicator(), // Loading indicator
      ):
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              title: Text("Product View",style: TextStyle(color: Colors.white),),
              backgroundColor: AppColors.primaryColor,
            ),
            Expanded( // Add Expanded widget here
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BigText(text: ' product overview', weight: FontWeight.bold),
                      const Text(
                        "Check the overall overview of the product",
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

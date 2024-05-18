import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hatbazarsample/Model/StoreAddress.dart';
import 'package:hatbazarsample/ProductCard/individualProductOverview.dart';
import 'package:hatbazarsample/SellerCenter/Product%20Detail/product_detail_home.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';
import 'package:hatbazarsample/Widgets/smallText.dart';

import '../ProductListPage/ProductListCat.dart';
import '../Services/get_imageBy_product_name.dart';
import '../main.dart';


class Product {
  final String name;
  final double rating;
  final double price;
  final String priceUnit;
  final int storeId;
  final String availableQty;

  @override
  String toString() {
    return 'Product{name: $name, rating: $rating, price: $price, priceUnit: $priceUnit, storeId: $storeId, availableQty: $availableQty}';
  }
  Product({required this.name,required this.storeId,required this.priceUnit, required this.rating, required this.price,required this.availableQty});
}

class ProductWidget extends StatefulWidget {

  final List<Product> products;


  const ProductWidget({Key? key, required this.products}) : super(key: key);

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}


class _ProductWidgetState extends State<ProductWidget> {
  List<String> productImages = [];

  @override
  void initState() {
    super.initState();
    fetchProductImages();
  }
  Uint8List decodeBase64ToUint8List(String base64String) {
    String base64Data = base64String.split(',').last;
    return base64.decode(base64Data);
  }
  Future<void> fetchProductImages() async {
    imageBytesList=[];
    try {
      for (var product in widget.products) {
        final images = await ImageFetcherService.fetchProductImages(product.name);
        productImages.addAll(images);
        for (var base64Image in images) {
          Uint8List imageBytes = decodeBase64ToUint8List(base64Image);
          imageBytesList.add(imageBytes);
        }
      }
      setState(() {});
    } catch (e) {
      print('Error fetching product images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the product using imageBytesList at index 0
        if (widget.products.isNotEmpty)
          GestureDetector(
            onTap: () {
              if(role=="Sellers"){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  ProductDetail(proName:widget.products[0].name),
                  ),
                );
              }
              else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductListCat(),
                  ),
                );
              }
              print("tapped");
            },
            child: Container(
              margin: EdgeInsets.only(right: ResponsiveDim.width15),
              decoration: BoxDecoration(
                color: const Color(0xB7F8F5EF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                          width: ResponsiveDim.screenHeight / 5,
                          height: ResponsiveDim.screenHeight / 5.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(ResponsiveDim.radius15),
                            image: productImages.isNotEmpty
                                ? DecorationImage(
                              fit: BoxFit.cover,
                              image: MemoryImage(base64Decode(productImages.first.replaceAll('data:image/png;base64,', ''))),
                            )
                                : null,
                          ),
                          child: productImages.isEmpty
                              ? Center(child: CircularProgressIndicator()) // Show CircularProgressIndicator if image is loading
                              : null
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BigText(
                              text: widget.products[0].name,
                              wrap: true,
                            ),
                            SizedBox(height: ResponsiveDim.height5,),
                            Row(
                              children: [
                                Wrap(
                                  children: [
                                    // Filled stars for the integer part
                                    ...List.generate(
                                      widget.products[0].rating.toInt(),
                                          (index) => Icon(Icons.star, color: Colors.cyan, size: ResponsiveDim.height15),
                                    ),
                                    // Partially filled star for the decimal part
                                    if (widget.products[0].rating % 1 > 0) // Check if there is a decimal part
                                      Icon(
                                        Icons.star_half,
                                        color: Colors.cyan,
                                        size: ResponsiveDim.height15,
                                      ),
                                    // Empty stars for the remaining part (if any)
                                    ...List.generate(
                                      (5 - widget.products[0].rating).toInt(), // Assuming a total of 5 stars
                                          (index) => Icon(Icons.star_border, color: Colors.cyan, size: ResponsiveDim.height15),
                                    ),
                                  ],
                                ),
                                SizedBox(width: ResponsiveDim.width10),
                                SmallText(text: "${widget.products[0].rating}/5"),
                                SizedBox(width: ResponsiveDim.width10),
                              ],
                            ),
                            SizedBox(height: ResponsiveDim.height5,),
                            BigText(
                              text: 'Rs ${widget.products[0].price} / ${widget.products[0].priceUnit}',
                              size: ResponsiveDim.height20,
                              weight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            SizedBox(height: ResponsiveDim.height5,),
                            SmallText(
                              text: 'Available Qty:  ${widget.products[0].availableQty} ${widget.products[0].priceUnit}',
                              size: ResponsiveDim.height15,
                              color: Colors.black,
                              overFlow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),


                ],
              ),
            ),
          ),
      ],
    );
  }
}

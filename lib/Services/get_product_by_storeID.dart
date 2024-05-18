import 'dart:async';
import 'dart:convert';
import 'package:hatbazarsample/Model/StoreAddress.dart';
import 'package:http/http.dart' as http;
import 'package:hatbazarsample/Utilities/constant.dart';

import '../OrderTracking/Order.dart';
import '../ProductCard/product.dart';
import '../main.dart' as main;
import '../main.dart';

int? productId;
Future<List<ProductDto>> fetchProductByStoreId(int storeId) async {
  productNames=[];
  final url = Uri.parse('${serverBaseUrl}products/store?storeId=$storeId');
  await StoreAddressService.fetchStoreAddress(storeId).then((storeAddress) {
    storeAddressJson = jsonDecode(storeAddress);
  });
  storeAddress = storeAddressJson["address"];
  print("here");
  print(storeAddress["county"]);


  final response = await http.get(url);

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    //productId=jsonResponse[0]["id"];
   // final url = Uri.parse('${serverBaseUrl}products/store?storeId=$productId');
    print("json response");
    print(jsonResponse[0]["name"]);
    productNameEnglish=jsonResponse[0]['name'] as String;
    productRate=jsonResponse[0]['price'].toString();
    productHighlights=jsonResponse[0]['highlights'] as String;
    productDescription=jsonResponse[0]['description'] as String;
    main.harvestedSeason= jsonResponse[0]['harvestedSeason'] as String ;
    main.availableQty= jsonResponse[0]['availableQty'] as double;
    main.qtyUnit= jsonResponse[0]['qtyUnit'] as String;
    main.availableDate= DateTime.parse(jsonResponse[0]['availableTill'] as String).toString();
    main.priceUnit= jsonResponse[0]['priceUnit'] as String;

    if (jsonResponse.isEmpty) {
      isAddProductCompleted = false;
    } else {
      isAddProductCompleted = true;
    }

    List<ProductDto> products = [];
    productLists=[];

    for (var productJson in jsonResponse) {
      ProductDto product = ProductDto.fromJson(productJson);
      products.add(product);
      productNames.add(product.name);
      // Create a Product object from ProductDto
      Product productToAdd = Product(
        storeId: product.storeId,
        name: product.name,
        rating: 4.5,
        price: product.price,
        priceUnit: product.priceUnit,
        availableQty: product.availableQty.toString()
      );
      print(productNames);
      // Add the Product object to productLists
      productLists.add([productToAdd]);
    }
    for(String products in  productNames){
      print("list is $products");
    }
    print(role);

    return products;
  }
  else {
    throw Exception('Failed to load products. Status code: ${response.statusCode}');
  }
}
// Future<List<ProductDto>> fetchProductById(int storeId) async {
//
// }
class ProductDto {
  final int id;
  final String name;
  final double price;
  final String description;
  final String highlights;
  final String category;
  final String subCategory;
  final String harvestedSeason;
  final double availableQty;
  final String qtyUnit;
  final DateTime availableTill;
  final String priceUnit;
  final int storeId;

  ProductDto({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.highlights,
    required this.category,
    required this.subCategory,
    required this.harvestedSeason,
    required this.availableQty,
    required this.qtyUnit,
    required this.availableTill,
    required this.priceUnit,
    required this.storeId,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {

    return ProductDto(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as double,
      description: json['description'] as String,
      highlights: json['highlights'] as String,
      category: json['category']['categoryName'] as String,
      subCategory: json['subCategory']['categoryName'] as String,
      harvestedSeason: json['harvestedSeason'] as String,
      availableQty: json['availableQty'] as double,
      qtyUnit: json['qtyUnit'] as String,
      availableTill: DateTime.parse(json['availableTill'] as String),
      priceUnit: json['priceUnit'] as String,
      storeId: json['storeId'] as int,
    );
  }
}

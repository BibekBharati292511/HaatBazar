import 'dart:async';
import 'dart:convert';
import 'package:hatbazarsample/Model/StoreAddress.dart';
import 'package:hatbazarsample/Recommendation/recommendation_service.dart';
import 'package:http/http.dart' as http;
import 'package:hatbazarsample/Utilities/constant.dart';

import '../ProductCard/product.dart';
import '../main.dart' as main;
import '../main.dart';

List<int> productIds=[];

// Maps to store productName and Id
RecommenderService services= new RecommenderService();

Future<List<ProductDto>> fetchAllProduct() async {
  List<int> item=[];
   item=await services.getRecommendation(userDataJson["id"]);
  if(item.isNotEmpty){
   for(int items in item){
     print(items);
   }
  }
  final url = Uri.parse('${serverBaseUrl}products/');
  final response = await http.get(url);
  List<dynamic> jsonResponse = jsonDecode(response.body);
  storeId = jsonResponse[0]["storeId"] as int;

  if (response.statusCode == 200) {
    await StoreAddressService.fetchStoreAddress(storeId!).then((storeAddress) {
      storeAddressJson = jsonDecode(storeAddress);
    });
    storeAddress = storeAddressJson["address"];
    storeId = jsonResponse[0]['storeId'] as int;
    productNameEnglish = jsonResponse[0]['name'] as String;
    productRate = jsonResponse[0]['price'].toString();
    productHighlights = jsonResponse[0]['highlights'] as String;
    productDescription = jsonResponse[0]['description'] as String;
    main.harvestedSeason = jsonResponse[0]['harvestedSeason'] as String;
    main.availableQty = jsonResponse[0]['availableQty'] as double;
    main.qtyUnit = jsonResponse[0]['qtyUnit'] as String;
    main.availableDate = DateTime.parse(jsonResponse[0]['availableTill'] as String).toString();
    main.priceUnit = jsonResponse[0]['priceUnit'] as String;

    if (jsonResponse.isEmpty) {
      isAddProductCompleted = false;
    } else {
      isAddProductCompleted = true;
    }

    List<ProductDto> products = [];
    productLists = [];
    productIds=[];

    for (var productJson in jsonResponse) {
      ProductDto product = ProductDto.fromJson(productJson);
      products.add(product);

      // Check for uniqueness before adding to the maps
      if (!idToProductName.containsKey(product.id) && !productNameToId.containsKey(product.name)) {
        idToProductName[product.id] = product.name;
        productNameToId[product.name] = product.id;
      }

      // Create a Product object from ProductDto
      Product productToAdd = Product(
        storeId: product.storeId,
        name: product.name,
        rating: 4.5,
        price: product.price,
        priceUnit: product.priceUnit,
        availableQty: product.availableQty.toString(),
      );
      if(!productIds.contains(product.id)) {
        productIds.add(product.id);
      }

// Clear recommendedProductLists before adding new recommendations
      recommendedProductLists.clear();

// Iterate over items and add corresponding products to recommendedProductLists
      for (int itemId in item) {
        ProductDto correspondingProduct = products.firstWhere((product) => product.id == itemId, orElse: () => ProductDto(id: -1, name: '', price: 0.0, description: '', highlights: '', category: '', subCategory: '', harvestedSeason: '', availableQty: 0.0, qtyUnit: '', availableTill: DateTime.now(), priceUnit: '', storeId: -1));

        if (correspondingProduct.id != -1) {
          // Process the corresponding product
          Product productToAdd = Product(
            storeId: correspondingProduct.storeId,
            name: correspondingProduct.name,
            rating: 4.5,
            price: correspondingProduct.price,
            priceUnit: correspondingProduct.priceUnit,
            availableQty: correspondingProduct.availableQty.toString(),
          );
          // Check if the productToAdd is not already in recommendedProductLists
          if (!recommendedProductLists.any((innerList) => innerList.contains(productToAdd))) {
            // Add the productToAdd to a new inner list
            recommendedProductLists.add([productToAdd]);
          }
        } else {
          // Handle the case when no corresponding product is found
          print('No product found with id: $itemId');
        }
      }

      if(recommendedProductLists.isNotEmpty){
        for(var products in recommendedProductLists){
          for(var product in products){
            print(product);
          }
        }
      }



      // Add the Product object to productLists
      productLists.add([productToAdd]);
    }
    print(idToProductName);
    print("sdafsd");
    print(productNameToId);

    print("Products:");
    print(role);

    return products;
  } else {
    throw Exception('Failed to load products. Status code: ${response.statusCode}');
  }
}

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

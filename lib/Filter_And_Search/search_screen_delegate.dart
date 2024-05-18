import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/Services/get_imageBy_product_name.dart';
import 'package:hatbazarsample/ProductCard/bigProductCardWidget.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import '../Model/UserData.dart';
import '../ProductListPage/ProductListCat.dart';
import '../Services/get_all_product.dart';

class ProductSearchDelegate extends SearchDelegate {
  final List<ProductDto> allProducts;
  final Map<int, List<dynamic>> _storeDataMap = {};
  final Map<int, String> _storeProducerMap = {};
  final Map<String, List<Uint8List>> _productImages = {};

  ProductSearchDelegate({required this.allProducts}) {
    _initialize();
  }

  // Function to decode Base64 to Uint8List
  Uint8List _decodeBase64ToUint8List(String base64String) {
    String base64Data = base64String.split(',').last;
    return base64.decode(base64Data);
  }

  void _initialize() async {
    for (ProductDto product in allProducts) {
      int storeId = product.storeId;

      if (!_storeDataMap.containsKey(storeId)) {
        var storeDataJson = await UserDataService.fetchStoreDataById(storeId);
        var storeData = jsonDecode(storeDataJson);

        if (storeData is List<dynamic> && storeData.isNotEmpty) {
          _storeDataMap[storeId] = storeData;
          var firstItem = storeData[0];
          _storeProducerMap[storeId] = firstItem.containsKey("name")
              ? firstItem["name"]
              : "Unknown Producer";
        }
      }

      // Fetch product images
      List<String> imageStrings = await ImageFetcherService.fetchProductImages(product.name);
      List<Uint8List> imageBytes = imageStrings.map(_decodeBase64ToUint8List).toList();

      _productImages[product.name] = imageBytes;
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search query
          Navigator.push(context,  MaterialPageRoute(
              builder: (context) => ProductListCat()));
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null), // Close the search overlay
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredProducts = allProducts
        .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (filteredProducts.isEmpty) {
      return Center(child: Text("No product found.")); // Handle empty results
    }

    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        int storeId = product.storeId;

        // Fetch producer name from the map
        String producerName = _storeProducerMap[storeId] ?? "Unknown Producer";

        // Fetch product images from the map
        List<Uint8List> imageBytes = _productImages[product.name] ?? [];

        return ProductCardBigWidget(
          storeId: product.storeId,
          productName: product.name,
          description: product.description,
          price: 'Rs. ${product.price} /Kg',
          producer: producerName,
          imageBytesList: imageBytes,
          rating: 4.5, // Default rating
          reviewCount: 35, // Default review count
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = allProducts
        .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion.name),
          onTap: () {
            query = suggestion.name; // Update the search query
            showResults(context); // Show results based on the suggestion
          },
        );
      },
    );
  }
}

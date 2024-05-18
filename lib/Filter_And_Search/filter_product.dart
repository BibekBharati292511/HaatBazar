import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Utilities/constant.dart';
import '../Services/get_all_product.dart';

class ProductFilterService {
  List<ProductDto> _products = []; // Original list of all products
  List<ProductDto> _filteredProducts = []; // New list for storing filtered products

  Future<void> fetchAllProducts() async {
    final response = await http.get(
      Uri.parse('${serverBaseUrl}products/'),
    );

    if (response.statusCode == 200) {
      List<dynamic> productData = jsonDecode(response.body);
      _products = productData.map((item) => ProductDto.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch all products');
    }
  }

  Future<void> fetchProductsByHarvestedSeason(String season) async {
    final response = await http.get(
      Uri.parse('${serverBaseUrl}products/harvested_season/$season'),
    );

    if (response.statusCode == 200) {
      List<dynamic> productData = jsonDecode(response.body);
      _filteredProducts = productData.map((item) => ProductDto.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch products by harvested season');
    }
  }

  Future<void> fetchProductsByPriceRange(double minPrice, double maxPrice) async {
    final response = await http.get(
      Uri.parse('${serverBaseUrl}products/price_range?minPrice=$minPrice&maxPrice=$maxPrice'),
    );

    if (response.statusCode == 200) {
      List<dynamic> productData = jsonDecode(response.body);
      _filteredProducts = productData.map((item) => ProductDto.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch products by price range');
    }
  }

  Future<void> fetchProductsByAvailableQtyRange(double minQty, double maxQty) async {
    final response = await http.get(
      Uri.parse('${serverBaseUrl}products/available_qty_range?minQty=$minQty&maxQty=$maxQty'),
    );

    if (response.statusCode == 200) {
      List<dynamic> productData = jsonDecode(response.body);
      _filteredProducts = productData.map((item) => ProductDto.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch products by available quantity range');
    }
  }
  Future<void> fetchProductsByCategoryId(int categoryId) async {
    final response = await http.get(
      Uri.parse('${serverBaseUrl}products/category?categoryId=$categoryId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> productData = jsonDecode(response.body);
      _filteredProducts = productData.map((item) => ProductDto.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch products by category');
    }
  }

  // Fetch products by sub-category ID
  Future<void> fetchProductsBySubCategoryId(int subCategoryId) async {
    final response = await http.get(
      Uri.parse('${serverBaseUrl}products/sub-category?subCategoryId=$subCategoryId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> productData = jsonDecode(response.body);
      _filteredProducts = productData.map((item) => ProductDto.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch products by sub-category');
    }
  }

  List<ProductDto> get filteredProducts => _filteredProducts; // Getter for filtered products
}

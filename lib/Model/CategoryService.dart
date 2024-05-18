import 'dart:convert';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:http/http.dart' as http;

class Category {
  final int id;
  final String categoryName;

  Category({required this.id, required this.categoryName});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      categoryName: json['categoryName'],
    );
  }
}

class CategoryService {
  static Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('${serverBaseUrl}category/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Category> categories = data.map((category) => Category.fromJson(category)).toList();
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<List<Category>> fetchSubcategories(int categoryId) async {
    final response = await http.get(Uri.parse('${serverBaseUrl}subCategory/listByCategoryId?category_id=$categoryId'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Category> subcategories = data.map((subcategory) => Category.fromJson(subcategory)).toList();
      return subcategories;
    } else {
      throw Exception('Failed to load subcategories');
    }
  }
}

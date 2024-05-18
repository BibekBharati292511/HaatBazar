import 'dart:convert';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:http/http.dart' as http;

class SubCategory {
  final int id;
  final String categoryName;
  final int subCategoryId;
  final String imageUrl;

  SubCategory({
    required this.id,
    required this.categoryName,
    required this.subCategoryId,
    required this.imageUrl,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      categoryName: json['categoryName'],
      subCategoryId: json['categoryId'],
      imageUrl: json['imageUrl'],
    );
  }
}

class SubCategoryService {

  Future<List<SubCategory>> getAllSubCategories() async {
    final response = await http.get(Uri.parse('${serverBaseUrl}subCategory/getAll'));
    if (response.statusCode == 200) {
      Iterable data = json.decode(response.body);
      return List<SubCategory>.from(data.map((category) => SubCategory.fromJson(category)));
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

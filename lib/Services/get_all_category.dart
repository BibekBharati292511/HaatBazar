import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hatbazarsample/Utilities/constant.dart';

import '../ProductCard/product.dart';
import '../main.dart' as main;

Future<List<CategoryDto>> fetchAllCategories() async {
  final url = Uri.parse('${serverBaseUrl}category/getALl');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    print(jsonResponse);

    List<CategoryDto> categories = [];

    for (var categoryJson in jsonResponse) {
      CategoryDto category = CategoryDto.fromJson(categoryJson);
      categories.add(category);
    }

    print("Categories:");
    print(categories);

    return categories;
  } else {
    throw Exception('Failed to load categories. Status code: ${response.statusCode}');
  }
}

class CategoryDto {
  final int id;
  final String categoryName;
  final String description;
  final String imageUrl;

  CategoryDto({
    required this.id,
    required this.categoryName,
    required this.description,
    required this.imageUrl,
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) {
    return CategoryDto(
      id: json['id'] as int,
      categoryName: json['categoryName'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}

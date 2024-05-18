import 'dart:convert';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:http/http.dart' as http;

class Categorys {
  final int id;
  final String categoryName;
  final String description;
  final String imageUrl;

  Categorys({
    required this.id,
    required this.categoryName,
    required this.description,
    required this.imageUrl,
  });

  factory Categorys.fromJson(Map<String, dynamic> json) {
    return Categorys(
      id: json['id'],
      categoryName: json['categoryName'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}

class CategoryServices {

  Future<List<Categorys>> getAllCategories() async {
    final response = await http.get(Uri.parse('${serverBaseUrl}category/getALl'));
    if (response.statusCode == 200) {
      Iterable data = json.decode(response.body);
      return List<Categorys>.from(data.map((category) => Categorys.fromJson(category)));
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

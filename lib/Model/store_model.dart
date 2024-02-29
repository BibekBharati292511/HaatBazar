import 'dart:convert';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:http/http.dart' as http;

List<String> globalDescriptionList = [];

class StoreType {
  final int id;
  final String type;
  final String description;

  StoreType({required this.id, required this.type, required this.description});

  factory StoreType.fromJson(Map<String, dynamic> json) {
    return StoreType(
      id: json['id'],
      type: json['type'],
      description: json['description'],
    );
  }

  String descriptionToJsonString() {
    return '{"description": "$description"}';
  }
}

Future<List<StoreType>> fetchTypes() async {
  final url = Uri.parse('${serverBaseUrl}store/getStoreType');

  try {
    final response = await http.get(
      url,
      headers: <String, String>{"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      List<dynamic> typesJson = jsonDecode(response.body);
      print("Store Types JSON: $typesJson");

      // Extract descriptions and store them in the globalDescriptionList
      globalDescriptionList = typesJson.map<String>((typeJson) {
        String description = typeJson["description"];
        return description;
      }).toList();

      List<StoreType> types = typesJson.map((typeJson) => StoreType.fromJson(typeJson)).toList();
      print("Store Types: $types");

      return types;
    } else {
      throw Exception('Failed to fetch store types: ${response.reasonPhrase}');
    }
  } catch (e) {
    // Handle network errors here
    print('Error fetching store types: $e');
    throw Exception('Failed to fetch store types: $e');
  }
}

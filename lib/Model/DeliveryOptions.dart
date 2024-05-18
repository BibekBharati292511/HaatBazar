import 'dart:convert';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:http/http.dart' as http;

List<String> globalDescriptionList = [];

class StoreDeliveryOptions {
  final int id;
  final String deliveryOptions;
  final String description;

  StoreDeliveryOptions({required this.id, required this.deliveryOptions, required this.description});

  factory StoreDeliveryOptions.fromJson(Map<String, dynamic> json) {
    return StoreDeliveryOptions(
      id: json['id'],
      deliveryOptions: json['deliveryOptions'],
      description: json['description'],
    );
  }

  String descriptionToJsonString() {
    return '{"description": "$description"}';
  }
}

Future<List<StoreDeliveryOptions>> fetchDeliveryOptions() async {
  final url = Uri.parse('${serverBaseUrl}deliveryOptions/getDeliveryOptions');

  try {
    final response = await http.get(
      url,
      headers: <String, String>{"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      List<dynamic> deliveryOptionsJson = jsonDecode(response.body);
      print("Store deliveryOptions JSON: $deliveryOptionsJson");

      // Extract descriptions and store them in the globalDescriptionList
      globalDescriptionList = deliveryOptionsJson.map<String>((typeJson) {
        String description = typeJson["description"];
        return description;
      }).toList();

      List<StoreDeliveryOptions> deliveryOptions = deliveryOptionsJson.map((typeJson) => StoreDeliveryOptions.fromJson(typeJson)).toList();
      print("Store deliveryOptions: $deliveryOptions");

      return deliveryOptions;
    } else {
      throw Exception('Failed to fetch store deliveryOptions: ${response.reasonPhrase}');
    }
  } catch (e) {
    // Handle network errors here
    print('Error fetching store deliveryOptions: $e');
    throw Exception('Failed to fetch store deliveryOptions: $e');
  }

}


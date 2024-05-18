import 'dart:convert';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:http/http.dart' as http;

List<String> globalDescriptionList = [];

class StorePaymentOptions {
  final int id;
  final String paymentOptions;
  final String description;

  StorePaymentOptions({required this.id, required this.paymentOptions, required this.description});

  factory StorePaymentOptions.fromJson(Map<String, dynamic> json) {
    return StorePaymentOptions(
      id: json['id'],
      paymentOptions: json['paymentOptions'],
      description: json['description'],
    );
  }

  String descriptionToJsonString() {
    return '{"description": "$description"}';
  }
}

Future<List<StorePaymentOptions>> fetchPaymentOptions() async {
  final url = Uri.parse('${serverBaseUrl}paymentOptions/getPaymentOptions');

  try {
    final response = await http.get(
      url,
      headers: <String, String>{"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      List<dynamic> paymentOptionsJson = jsonDecode(response.body);
      print("Store paymentOptions JSON: $paymentOptionsJson");

      // Extract descriptions and store them in the globalDescriptionList
      globalDescriptionList = paymentOptionsJson.map<String>((typeJson) {
        String description = typeJson["description"];
        return description;
      }).toList();

      List<StorePaymentOptions> paymentOptions = paymentOptionsJson.map((typeJson) => StorePaymentOptions.fromJson(typeJson)).toList();
      print("Store paymentOptions: $paymentOptions");

      return paymentOptions;
    } else {
      throw Exception('Failed to fetch store paymentOptions: ${response.reasonPhrase}');
    }
  } catch (e) {
    // Handle network errors here
    print('Error fetching store paymentOptions: $e');
    throw Exception('Failed to fetch store paymentOptions: $e');
  }

}


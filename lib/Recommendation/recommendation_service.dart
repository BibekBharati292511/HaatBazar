import 'dart:convert';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:http/http.dart' as http;

class RecommenderService {
  final String baseUrl = '${serverBaseUrl}recommendations';

  Future<List<int>> getRecommendation(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/recommend?userId=$userId'));
    if(response.body.isEmpty){
      return [];
    }
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      // Extract itemIDs from jsonResponse
      List<int> itemIDs = jsonResponse.map<int>((item) => item['itemID']).toList();

      return itemIDs;
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  Future<String> addData(int userId, int itemId, int rating) async {
    final response = await http.post(
      Uri.parse('$baseUrl/addData'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, int>{
        'userId': userId,
        'itemId': itemId,
        'rating': rating,
      }),
    );

    if (response.statusCode == 200) {
      return 'Data added successfully';
    } else {
      throw Exception('Failed to add data');
    }
  }

  Future<String> addDataWithJson(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/addData'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return 'Data added successfully';
    } else {
      throw Exception('Failed to add data');
    }
  }
}

class Recommendation {
  final int itemId;

  Recommendation({required this.itemId,});

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      itemId: json['itemID'],
    );
  }
}

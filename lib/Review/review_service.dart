import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hatbazarsample/Review/review_model.dart';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class ReviewService {
  static  String baseUrl = '${serverBaseUrl}reviews';

  Future<void> addReview({
    required BuildContext context,
     int? rating,
     String? comment,
    required String ratingFrom,
    required String ratingTo,
    Uint8List? profileImage,
  }) async {
    final Map<String, dynamic> requestData = {
      'rating': rating,
      'comment': comment,
      'ratingFrom': ratingFrom,
      'ratingTo': ratingTo,
      'profileImage': base64Decode(userDataJson['image']??""),
    };

    final http.Response response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      print("respise ");
      print(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Review cannot be added at the moment"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> deleteReviewsById(int id,BuildContext context) async {
    final http.Response response = await http.delete(
      Uri.parse('$baseUrl/id?id=$id'),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Review Deleted successfully"), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Review cannot be deleted at the moment"), backgroundColor: Colors.red),
      );
    }
  }

  Future<List<Review>> getReviewsByRatingTo(String ratingTo) async {
    final http.Response response = await http.get(
      Uri.parse('$baseUrl/ratingTo?ratingTo=$ratingTo'),
    );
    print("hel;loofsfda");

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<double> getAverageRatingByRatingTo(String ratingTo) async {
    final http.Response response = await http.get(
      Uri.parse('$baseUrl/average/ratingTo?ratingTo=$ratingTo'),
    );

    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      throw Exception('Failed to get average rating');
    }
  }
}

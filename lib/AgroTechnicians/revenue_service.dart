import 'dart:convert';
import 'package:hatbazarsample/AgroTechnicians/revenue_model.dart';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:http/http.dart' as http;


class RevenueService {
  final String baseUrl = '${serverBaseUrl}revenue';

  Future<void> addRevenue(Revenue revenue) async {
    final response = await http.put(
      Uri.parse('$baseUrl/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(revenue.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add revenue: ${response.body}');
    }
  }

  Future<List<Revenue>> findRevenueByToken(String token) async {
    final response = await http.get(Uri.parse('$baseUrl/find/token?token=$token'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Revenue.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load revenue');
    }
  }

  Future<List<Revenue>> findRevenueByTokenAndLastWeek(String token) async {
    final response = await http.get(Uri.parse('$baseUrl/find/lastWeek?token=$token'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Revenue.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load revenue for last week');
    }
  }

  Future<List<Revenue>> findRevenueByTokenAndLastMonth(String token) async {
    final response = await http.get(Uri.parse('$baseUrl/find/lastMonth?token=$token'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Revenue.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load revenue for last month');
    }
  }

  Future<List<Revenue>> findRevenueByTokenAndLast15Days(String token) async {
    final response = await http.get(Uri.parse('$baseUrl/find/last15Days?token=$token'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Revenue.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load revensue for last 90 days');
    }
  }

  Future<double> getTotalRevenueForUser(String token) async {
    final response = await http.get(Uri.parse('$baseUrl/total?token=$token'));

    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      throw Exception('Failed to get total revenue for user');
    }
  }

  Future<void> deleteAllRevenueByToken(String token) async {
    final response = await http.delete(Uri.parse('$baseUrl/deleteAllByToken?token=$token'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete all revenue for token: ${response.body}');
    }
  }

  Future<void> deleteRevenueOlderThan60Days() async {
    final response = await http.delete(Uri.parse('$baseUrl/deleteOlderThan60Days'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete revenue older than 60 days: ${response.body}');
    }
  }
}

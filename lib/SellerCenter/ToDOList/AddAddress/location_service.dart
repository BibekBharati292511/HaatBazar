import 'dart:convert';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:http/http.dart' as http;

Future<http.Response> getLocationData(String text) async {
  http.Response response;

  response = await http.get(
    Uri.parse("${serverBaseUrl}place/autocomplete?search_text=$text"),
    headers: {"Content-Type": "application/json"},);
print("From location service");
  print(jsonDecode(response.body));
  return response;
}
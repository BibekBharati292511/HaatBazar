import 'dart:convert';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:hatbazarsample/main.dart';
import 'package:http/http.dart' as http;

class ProfileCompletionTracker {
  static Future<void> profileCompletionTracker() async {
    final url = Uri.parse("${serverBaseUrl}user/checkProfileStats");
    try {
      final response = await http.post(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, Object>{
          "email":userEmail!,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody["status"] == "Success") {
          isProfileCompleted = true;
          print(isProfileCompleted);
        }
        if (responseBody['status'] == 'Error') {
          isProfileCompleted = false;
          print(isProfileCompleted);
        }
      } else {
        print("Error:${response.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

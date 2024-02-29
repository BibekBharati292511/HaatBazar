import 'dart:convert';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:hatbazarsample/main.dart';
import 'package:http/http.dart' as http;

class StoreProfileCompletionTracker {
  static Future<void> storeProfileCompletionTracker() async {
    final url = Uri.parse("${serverBaseUrl}store/checkStoreProfileStats");
    try {
      final response = await http.post(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, Object>{
          "token":userToken!,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody["tracker"] == true) {
          isStoreProfileCompleted=true;
        }
        if (responseBody['tracker'] == 'false') {
          isStoreProfileCompleted=false;
        }
      } else {
        print("Error:${response.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
class StoreNumberCompletionTracker {
  static Future<void> storeNumberCompletionTracker() async {
    final url = Uri.parse("${serverBaseUrl}store/checkStoreNumberStats");
    try {
      final response = await http.post(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, Object>{
          "token":userToken!,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody["tracker"] == true) {
          isAddStoreNumberCompleted=true;
        }
        if (responseBody['tracker'] == 'false') {
          isAddStoreNumberCompleted=false;
        }
      } else {
        print("Error:${response.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
class StoreImageCompletionTracker {
  static Future<void> storeImageCompletionTracker() async {
    final url = Uri.parse("${serverBaseUrl}store/checkStoreImageStats");
    try {
      final response = await http.post(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, Object>{
          "token":userToken!,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody["tracker"] == true) {
          isAddStoreImageCompleted=true;
        }
        if (responseBody['tracker'] == 'false') {
          isAddStoreImageCompleted=false;
        }
      } else {
        print("Error:${response.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}



import 'dart:convert';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:hatbazarsample/main.dart';
import 'package:http/http.dart' as http;

class AddressTracker {
  static Future<void> addressTracker() async {
    final url = Uri.parse("${serverBaseUrl}address/checkAddressStats");
    try {
      final response = await http.post(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, Object>{
          "id":userDataJson["id"],
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("address tracker success $responseBody");
        if (responseBody["status"] == "Success") {
          isAddAddressCompleted=true;
          print(isAddAddressCompleted);
        }
        if (responseBody['status'] == 'Error') {
          isAddAddressCompleted = false;
          print(isAddAddressCompleted);
        }
      } else {
        print("Error:${response.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

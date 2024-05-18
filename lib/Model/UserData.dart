import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:http/http.dart' as http;

class UserDataService {
  static Future<String> fetchUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${serverBaseUrl}user/getUsers'),
        headers: {
          'Authorization': token,
        },
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load user data: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }
  static Future<String> fetchStoreData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${serverBaseUrl}store/getStores?token=$token'),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load store data: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load store data: $e');
    }
  }
  static Future<String> fetchStoreDataById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${serverBaseUrl}store/getStores/id?id=$id'),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load user data: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }

}

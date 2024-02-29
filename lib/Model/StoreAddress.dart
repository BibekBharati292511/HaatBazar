import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:http/http.dart' as http;

class StoreAddressService {
  static Future<String> fetchStoreAddress(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${serverBaseUrl}storeAddress/getUserAddress?store_id=$id'),
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

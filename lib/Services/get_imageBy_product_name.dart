import 'dart:convert';
import 'dart:typed_data';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:http/http.dart' as http;

class ImageFetcherService {
  static Future<List<String>> fetchProductImages(String productName) async {
    try {
      final Uri url = Uri.parse('${serverBaseUrl}images/product?productName=$productName');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
       // print(data);

        // Decode base64 images
        List<String> decodedImages = data.map<String>((product) {
          String base64Image = product['productImage'];
          Uint8List bytes = base64.decode(base64Image.split(',').last);
          return 'data:image/png;base64,' + base64.encode(bytes);
        }).toList();

        return decodedImages;
      } else {
        print('Error: ${response.statusCode}');
        throw Exception('Failed to load product images');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Error fetching product images: $e');
    }
  }
}

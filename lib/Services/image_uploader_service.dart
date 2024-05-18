import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../Utilities/constant.dart';

Future<http.Response> uploadImageService(List<Uint8List> imageBytesList, String productName) async {
  var url = Uri.parse('${serverBaseUrl}images/save');

  try {
    // Encode each image byte list to base64
    List<String> base64Images = imageBytesList.map((bytes) => base64Encode(bytes)).toList();

    // Create a list of Map objects, each representing an ImageDto
    List<Map<String, dynamic>> imageDtoList = base64Images.map((base64Image) {
      return {
        'productImage': base64Image,
        'productName': productName,
      };
    }).toList();

    // Create the request body
    var requestBody = jsonEncode(imageDtoList);

    // Send the POST request
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestBody,
    );

    return response;
  } catch (e) {
    print('Error uploading images: $e');
    throw e;
  }
}

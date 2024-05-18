import 'dart:convert';
import 'package:flutter/material.dart';
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
  static Future<void> storeAddressTracker() async {
    final url = Uri.parse("${serverBaseUrl}storeAddress/checkAddressStats?store_id=${storeDataJson[0]["id"]}");
    try {
      final response = await http.post(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("address tracker success $responseBody");
        if (responseBody["status"] == "Success") {
          isStoreAddressCompleted=true;
          print("sucess");
        }
        if (responseBody['status'] == 'Error') {
          print(storeDataJson[0]["id"]);
          isStoreAddressCompleted = false;
          print("Fail");
        }
      } else {
        print("Error:${response.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  static Future<void> storeDeliveryTracker() async {
    final storeId = storeDataJson[0]["id"];
    final url = Uri.parse("${serverBaseUrl}storeDeliveryOptions/CheckStoreDeliveryOptionsStats?store_id=$storeId");

    try {
      final response = await http.get(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("delivery tracker success $responseBody");
        if (responseBody["status"] == "Success") {
          isStoreDeliveryOptionCompleted = true;
          print("ducess");
        }
        if (responseBody['status'] == 'Error') {
          print(storeDataJson[0]["id"]);
          isStoreDeliveryOptionCompleted = false;
          print("Failedddddddddddd friom storeDelivery Tracker");
        }
      } else {
        print("Error:${response.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  static Future<void> storePaymentTracker() async {
    final storeId = storeDataJson[0]["id"];
    final url = Uri.parse("${serverBaseUrl}storePaymentOptions/CheckStorePaymentOptionsStats?store_id=$storeId");

    try {
      final response = await http.get(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("payment tracker success $responseBody");
        if (responseBody["status"] == "Success") {
          isStorePaymentOptionCompleted = true;
          print("ducess");
        }
        if (responseBody['status'] == 'Error') {
          print(storeDataJson[0]["id"]);
          isStorePaymentOptionCompleted = false;
          print("Failedddddddddddd friom storePayment Tracker");
        }
      } else {
        print("Error:${response.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  static Future<void> productTracker() async {
    final storeId = storeDataJson[0]["id"];
    final url = Uri.parse("${serverBaseUrl}products/checkAddProductCompleted?storeId=$storeId");

    try {
      final response = await http.get(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("delivery tracker success $responseBody");
        if (responseBody["status"] == "Success") {
          isAddProductCompleted = true;
          print("prudct trcker true");
        }
        if (responseBody['status'] == 'Error') {
          print(storeDataJson[0]["id"]);
          isAddProductCompleted = false;
          print("prudct trcker false");
        }
      } else {
        print("Error:${response.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

}

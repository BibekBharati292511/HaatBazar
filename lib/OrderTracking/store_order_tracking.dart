import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/ProductListPage/ProductListCat.dart';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:http/http.dart' as http;

import 'Order.dart';



Future<void> orderTracker(String orderId, String message) async {

  final trackingMessage = {
    'orderId': orderId,
    'message': message,
  };

  final trackingBody = json.encode(trackingMessage);

  try {
    final response = await http.post(
      Uri.parse('${serverBaseUrl}order-process-tracker/add'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: trackingBody,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('Order tracking message added successfully');
    } else {
      debugPrint('Failed to add order tracking message: ${response.statusCode}');
      throw Exception('Failed to add order tracking message');
    }
  } catch (error) {
    // Handle exceptions, including network issues
    debugPrint('An error occurred while adding order tracking message: $error');
    throw Exception('Error while adding order tracking message: $error');
  }
}




Future<void> storeOrderInDatabase(OrderTracking order, BuildContext context) async {
  final orderUrl = Uri.parse('${serverBaseUrl}orders/create'); // Endpoint for POST request to create order
  final trackingUrl = Uri.parse('${serverBaseUrl}order-process-tracker/add'); // Endpoint to add tracking message

  final headers = {
    'Content-Type': 'application/json', // Specify the content type
  };

  // Convert the order object to a JSON string
  final orderBody = json.encode(order.toJson());

  // Send the POST request to store the order
  final orderResponse = await http.post(
    orderUrl,
    headers: headers,
    body: orderBody,
  );

  if (orderResponse.statusCode == 200 || orderResponse.statusCode == 201) {
    debugPrint('Order stored successfully');

    // If the order is successfully stored, add an initial tracking message
    final trackingMessage = {
      'orderId': order.orderId,
      'message': 'Order placed on ${DateTime.now()}', // Initial tracking message
    };

    final trackingBody = json.encode(trackingMessage); // Convert the message to JSON

    final trackingResponse = await http.post(
      trackingUrl,
      headers: headers,
      body: trackingBody,
    );

    if (trackingResponse.statusCode == 200 || trackingResponse.statusCode == 201) {
      debugPrint('Tracking message added successfully'); // Success message
    } else {
      debugPrint('Failed to add tracking message: ${trackingResponse.statusCode}'); // Error message
      throw Exception('Failed to add tracking message');
    }
  } else {
    debugPrint('Failed to store order: ${orderResponse.statusCode}'); // Error message
    throw Exception('Failed to store order'); // erroer handling
  }
}

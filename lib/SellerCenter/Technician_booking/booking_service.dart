import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:hatbazarsample/main.dart';
import 'package:http/http.dart' as http;
import '../../HomePage/bottom_navigation.dart';
import 'booking_model.dart';


  // Get all bookings
  Future<List<BookingModel>> getAllBookings() async {
    final response = await http.get(Uri.parse(serverBaseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => BookingModel.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load bookings");
    }
  }

  // Create a new booking
  Future<BookingModel> createBooking(BuildContext context,BookingModel booking, String email) async {
    final response = await http.post(
      Uri.parse("${serverBaseUrl}bookings/create"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(booking.toJson()),
    );
    if (response.statusCode == 200) {
      notificationService.createNotification(
          email,
          "You have got a new booking request",
          "",
          "confirmBooking",
          false
      );
      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(content: Text("Booking Request sent successfully"),backgroundColor: Colors.green,),
      );
      technicianBookingReqSent=true;
      final data = jsonDecode(response.body);
      return BookingModel.fromJson(data);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(content: Text("Process failed, Try agai later"),backgroundColor: Colors.green,),
      );
      throw Exception("Failed to create booking");
    }
  }

  // Update a booking
  Future<BookingModel> updateBooking(int id, BookingModel booking) async {
    final response = await http.put(
      Uri.parse("${serverBaseUrl}bookings/update/id?id=$id"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(booking.toJson()),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return BookingModel.fromJson(data);
    } else {
      throw Exception("Failed to update booking");
    }
  }

  // Delete a booking
  Future<void> deleteBooking(int id) async {
    final response = await http.delete(
      Uri.parse("${serverBaseUrl}bookings/delete?id=$id"),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to delete booking");
    }
  }

  // Get bookings by sellerToken
  Future<List<BookingModel>> getBookingsBySellerToken(String sellerToken) async {
    final response = await http.get(
      Uri.parse("${serverBaseUrl}bookings/seller/sellerToken?sellerToken=$sellerToken"),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => BookingModel.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load bookings by seller token");
    }
  }


  Future<List<BookingModel>> getBookingsByTechnicianToken(String status, String technicianToken) async {
    final response = await http.get(
      Uri.parse("${serverBaseUrl}bookings/technician/technicianToken?status=$status&technicianToken=$technicianToken"),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => BookingModel.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load bookings by technician token ${response.body}");
    }
  }
Future<List<BookingModel>> getBookingsByStatusAndSellerToken(String status, String technicianToken) async {
  final response = await http.get(
    Uri.parse("${serverBaseUrl}bookings/seller/sellerToken?status=$status&sellerToken=$technicianToken"),
  );
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => BookingModel.fromJson(item)).toList();
  } else {
    throw Exception("Failed to load bookings by technician token ${response.body}");
  }
}

  // Get bookings by status
  Future<List<BookingModel>> getBookingsByStatus(String status) async {
    final response = await http.get(
      Uri.parse("${serverBaseUrl}bookings/status/status?status=$status"),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => BookingModel.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load bookings by status");
    }

  }
Future<Map<String, int>> getStatusCount(String token) async {
  final response = await http.get(
    Uri.parse("${serverBaseUrl}bookings/statusCount?token=$token"),
  );
  if (response.statusCode == 200) {
    final Map<String, int> data = Map<String, int>.from(jsonDecode(response.body));
    return data;
  } else {
    throw Exception("Failed to get status count");
  }
}
Future<void> updateBookingStatus(int id,String status) async {
  final response = await http.put(
    Uri.parse("${serverBaseUrl}bookings/update/id?id=$id"),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(
        {
          "status":status
        }
    ),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to update order tracking');
  }

}


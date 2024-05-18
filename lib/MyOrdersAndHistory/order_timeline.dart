import 'package:flutter/material.dart';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Utilities/colors.dart';
import '../Widgets/bigText.dart';
import 'order_process_history_widget.dart';

Future<List<OrderProcessHistory>> fetchOrderHistory(String orderId) async {
  final response = await http.get(
    Uri.parse('${serverBaseUrl}order-process-tracker/history/?orderId=$orderId'),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => OrderProcessHistory.fromJson(item)).toList();
  } else {
    throw Exception("Failed to fetch order history");
  }
}

class OrderTimelineScreen extends StatelessWidget {
  final String orderId;

  const OrderTimelineScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BigText(text: "Order Timeline", color: Colors.white),
        backgroundColor: AppColors.primaryColor,
      ),
      body: FutureBuilder<List<OrderProcessHistory>>(
        future: fetchOrderHistory(orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error fetching order history"));
          }

          final orderHistory = snapshot.data!;

          return ListView.builder(
            itemCount: orderHistory.length + 1,
            itemBuilder: (context, index) {
              if (index < orderHistory.length) {
                final history = orderHistory[index];
                IconData icon = Icons.circle;

                if (history.message.contains("placed")) {
                  icon = Icons.shopping_bag;
                } else if (history.message.contains("approved")) {
                  icon = Icons.check_circle;
                } else if (history.message.contains("Shipment")) {
                  icon = Icons.local_shipping;
                }
                else if (history.message.contains("delivered")) {
                  icon = Icons.local_shipping_sharp;
                }
                else if (history.message.contains("Completed")) {
                  icon = Icons.check_circle;
                }


                return TimelineEvent(
                  icon: icon,
                  label: "Event ${index + 1}",
                  message: history.message,
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                     SizedBox(height: 100,),
                      Text(
                        "© 2024 HaatBazar. All rights reserved.",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hatbazarsample/Notification/notification_page.dart';
import 'package:http/http.dart' as http;

import '../../Notification/notification_service.dart';
import '../../OrderTracking/store_order_tracking.dart';
import '../../Utilities/ResponsiveDim.dart';
import '../../Widgets/custom_button.dart';
import 'order_request.dart';
import 'order_services_seller.dart';

class RequestCompletionButton extends StatelessWidget {
  final String orderId;
  final String buyerId;
  final NotificationService notificationService;

  RequestCompletionButton({
    required this.orderId,
    required this.buyerId,
    required this.notificationService,
  });

  Future<void> requestCompletion() async {
    try {
      await notificationService.createNotification(
        buyerId,
        "Please confirm completion of order: $orderId",
        orderId,
        "confirmDelivery",
        false
      );
    } catch (e) {
      throw Exception("Failed to send request completion notification");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () async {
        try {
          await requestCompletion(); // Trigger the request
          await orderTracker(
            orderId,
            "Order delivered on date ${DateTime.now()}",
          );
          await updateOrderTracking(orderId,"Completion_Requested");

          ScaffoldMessenger.of(context).showSnackBar(

            SnackBar(content: Text("Completion request sent to buyer"),backgroundColor: Colors.green,),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to send completion request"),backgroundColor: Colors.black,),
          );
        }
        Navigator.push(context, MaterialPageRoute(builder: (context)=> orderRequest()));
      },
      buttonText:"Request Completion",
      width: ResponsiveDim.screenWidth,
      color: Colors.redAccent,
    );
  }
}

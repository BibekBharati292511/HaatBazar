import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:hatbazarsample/Notification/notification_service.dart' as customNotification;
import 'package:hatbazarsample/SellerCenter/Technician_booking/SellerBookingHistory.dart';
import 'package:hatbazarsample/SellerCenter/Technician_booking/booking_service.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';

import '../MyOrdersAndHistory/order_and_history_main.dart';
import '../OrderTracking/store_order_tracking.dart';
import '../SellerCenter/order_request/order_services_seller.dart';
import '../Widgets/custom_button.dart';

class NotificationPage extends StatefulWidget {
  final String userId;
  final customNotification.NotificationService notificationService;

  const NotificationPage({
    required this.userId,
    required this.notificationService,
    Key? key,
  }) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}


class _NotificationPageState extends State<NotificationPage> {
  late Future<List<customNotification.Notification>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = widget.notificationService.getNotifications(widget.userId);
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      await widget.notificationService.markAsRead(notificationId);
      setState(() {
        _notificationsFuture = widget.notificationService.getNotifications(widget.userId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to mark notification as read")),
      );
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    try {
      await widget.notificationService.deleteNotification(notificationId);
      setState(() {
        _notificationsFuture = widget.notificationService.getNotifications(widget.userId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete notification")),
      );
    }
  }
  void showConfirmationDialog(
      BuildContext context, String message, String orderId, int notiId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delivery Confirmation"),
          content: Text(message),
          actions: [
            CustomButton(
              buttonText: "OK",
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      OrderAndHistoryMainPage()),
                );
               // await deleteNotification(notiId);
              },
            ),
          ],
        );
      },
    );
  }
  void showAppointmentConfirmationDialog(
      BuildContext context, String message, String orderId, int notiId) {
    int id=int.parse(orderId);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Appointment Completion Confirmation"),
          content: Text(message),
          actions: [
            CustomButton(
              buttonText: "Compete now",
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const SellerHistoryPage()
                ));
                Navigator.of(context).pop();


              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: BigText(text: "Notifications",color: Colors.white,),backgroundColor: AppColors.primaryColor,),
      body: FutureBuilder<List<customNotification.Notification>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error fetching notifications"));
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return Center(child: Text("No notifications available"));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final isRead = notification.isRead;
              final bgColor = isRead ? Colors.white : Colors.white70;

               return Column(
                children: [
                  SizedBox(height: 5,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0), // Padding
                    child: Dismissible(
                      key: Key(notification.id.toString()),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => deleteNotification(notification.id),
                      child: GestureDetector(
                        onTap: () {
                          if (!isRead) {
                            markAsRead(notification.id);
                          }

                          if (notification.actionType == "confirmDelivery") {
                            showConfirmationDialog(
                              context,
                              "Please make sure to check the product before confirmation.",
                              notification.relatedOrderId,
                              notification.id
                            );
                          }
                          else if(notification.actionType=="AppointmentCompletion"){
                            showAppointmentConfirmationDialog(
                                context,
                                "Please make sure that you are satisfied with appointment",
                                notification.relatedOrderId,
                                notification.id
                            );
                          }
                        },
                        child: Card(
                          color: bgColor,
                          elevation: isRead?0.4:2,
                          child: ListTile(
                            title: Text(notification.message),
                            subtitle: Text("Time: ${notification.timestamp}"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

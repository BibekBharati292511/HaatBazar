import 'package:flutter/material.dart';
import 'package:hatbazarsample/AgroTechnicians/revenue_chart.dart';
import 'package:hatbazarsample/AgroTechnicians/sheduled_task.dart';
import 'package:hatbazarsample/main.dart';

import '../Notification/notification_page.dart';
import '../Notification/notification_service.dart';
import '../Review/view_reviews.dart';
import 'booking_history.dart';
import 'models.dart';

class TechnicianDrawer extends StatelessWidget {
  final NotificationService notificationService = NotificationService();
   TechnicianDrawer({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double textHeightPercentage = 0.006; // Adjust this value based on your needs

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Haat-Bazar",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.red[300],
                  height: screenHeight * textHeightPercentage,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, 'technicianHome'); // Navigate to Home page
          },
          leading: Icon(
            Icons.home,
            color: Colors.black,
          ),
          title: Text("Home"),
        ),
        ListTile(
          onTap: () {
            // Navigate to Schedules page
          //  Navigator.push(context, MaterialPageRoute(builder: (context)=>AllScheduledTasksPage(schedules: ongoingSchedules)));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HistoryPage(),
              ),
            );
          },
          leading: Icon(
            Icons.schedule,
            color: Colors.black,
          ),
          title: Text("History"),
        ),
        ListTile(
          onTap: () {
            // Navigate to Bookings page

          },
          leading: Icon(
            Icons.book_online,
            color: Colors.black,
          ),
          title: Text("Bookings"),
        ),
        ListTile(
          onTap: () {
            // Navigate to Revenue page
            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => RevenuePage(token:token)));
          },
          leading: Icon(
            Icons.attach_money,
            color: Colors.black,
          ),
          title: Text("Revenue"),
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ReviewAndRatings(ratingTo: token,)));
          },
          leading: Icon(
            Icons.preview,
            color: Colors.black,
          ),
          title: Text("Ratings and Reviews"),
        ),
        ListTile(
          onTap: () {
            // Navigate to Notifications page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationPage(
                  userId: userEmail!,
                  notificationService: notificationService,
                ),
              ),
            );
          },
          leading: Icon(
            Icons.notifications,
            color: Colors.black,
          ),
          title: Text("Notifications"),
        ),
        ListTile(
          onTap: () {
            // Navigate to Accessibility options
          },
          leading: Icon(
            Icons.accessibility,
            color: Colors.black,
          ),
          title: Text("Accessibility"),
        ),
        ListTile(
          onTap: () {
            // Navigate to Help section
          },
          leading: Icon(
            Icons.help_outline,
            color: Colors.black,
          ),
          title: Text("Help"),
        ),
        ListTile(
          onTap: () {
            // Logout functionality
            _logout(context);
          },
          leading: Icon(
            Icons.logout,
            color: Colors.black,
          ),
          title: Text("Logout"),
        ),
      ],
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushNamed(context, 'login'); // Logout
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}

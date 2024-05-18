import 'package:flutter/material.dart';
import 'package:hatbazarsample/MyOrdersAndHistory/order_and_history_main.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double textHeightPercentage = 0.006;

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
            // Navigate to Home page
            Navigator.pushNamed(context, 'homePage');
          },
          leading: const Icon(
            Icons.home,
            color: Colors.black,
          ),
          title: const Text("Home"),
        ),
        ListTile(
          onTap: () {
            // Navigate to Profile page

          },
          leading: const Icon(
            Icons.person,
            color: Colors.black,
          ),
          title: const Text("Profile"),
        ),
        ListTile(
          onTap: () {

          },
          leading: const Icon(
            Icons.newspaper,
            color: Colors.black,
          ),
          title: const Text("News"),
        ),
        ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const OrderAndHistoryMainPage()));
          },
          leading: const Icon(
            Icons.shopping_bag_outlined,
            color: Colors.black,
          ),
          title: const Text("My Orders"),
        ),
        ListTile(
          onTap: () {
            // Navigate to Help section
          },
          leading: const Icon(
            Icons.help_outline,
            color: Colors.black,
          ),
          title: const Text("Help"),
        ),
        ListTile(
          onTap: () {
            // Navigate to Accessibility options
          },
          leading: const Icon(
            Icons.accessibility,
            color: Colors.black,
          ),
          title: const Text("Accessibility"),
        ),
        ListTile(
          onTap: () {
            // Logout functionality
            _logout(context);
          },
          leading: const Icon(
            Icons.logout,
            color: Colors.black,
          ),
          title: const Text("Logout"),
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

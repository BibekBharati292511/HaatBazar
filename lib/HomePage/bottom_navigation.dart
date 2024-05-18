import 'package:flutter/material.dart';
import 'package:hatbazarsample/Feed/feed_main.dart';
import 'package:hatbazarsample/HomePage/productPageBody.dart';
import 'package:hatbazarsample/Notification/notification_page.dart';
import 'package:hatbazarsample/Notification/notification_service.dart';
import 'package:hatbazarsample/main.dart';

import '../Utilities/colors.dart';

class BottomWidget extends StatefulWidget {
  const BottomWidget({Key? key}) : super(key: key);

  @override
  _BottomWidgetState createState() => _BottomWidgetState();
}

final NotificationService notificationService = NotificationService();

class _BottomWidgetState extends State<BottomWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  // The main content of the app, without Notifications
  static List<Widget> _widgetOptions = <Widget>[
    ProductPageBody(),
    FeedMain(),
    Text('Messages', style: optionStyle),
    Text('Account', style: optionStyle),
  ];

  void _onItemTapped(int index) {
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationPage(
            userId: userEmail!,
            notificationService: notificationService,
          ),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: AppColors.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
            backgroundColor: AppColors.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger),
            label: 'Messages',
            backgroundColor:AppColors.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
            backgroundColor: AppColors.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: _buildNotificationIcon(),
            label: 'Notification',
            backgroundColor: AppColors.primaryColor
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[500],
        onTap: _onItemTapped,
      ),
    );
  }
  Widget _buildNotificationIcon() {
    return Stack(
      children: [
        Icon(Icons.notifications),
        if (notificationCount > 0) // Only show badge if there's a count
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$notificationCount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

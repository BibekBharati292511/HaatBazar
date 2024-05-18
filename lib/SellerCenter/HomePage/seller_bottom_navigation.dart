import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hatbazarsample/Feed/feed_main.dart';
import 'package:hatbazarsample/SellerCenter/HomePage/seller_landing_page.dart';
import 'package:hatbazarsample/SellerCenter/HomePage/toDoListSeller.dart';
import 'package:hatbazarsample/SellerCenter/Tools/seller_tools.dart';
import '../../Utilities/colors.dart';
import '../../main.dart';

class MyController extends GetxController {
  var isAddProductCompleted = false.obs;
}

class SellerBottomNavigation extends StatefulWidget {
  const SellerBottomNavigation({Key? key}) : super(key: key);

  @override
  _SellerBottomNavigationState createState() => _SellerBottomNavigationState();
}

class _SellerBottomNavigationState extends State<SellerBottomNavigation> {
  int _selectedIndex = 0;
  final MyController _controller = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MyController>(
        builder: (controller) {
          // Check if all conditions are met
          bool allConditionsMet = isProfileCompleted &&
              isAddAddressCompleted &&
              isAddStoreCompleted &&
              isAddProductCompleted;
          List<Widget> _widgetOptions = <Widget>[
            SingleChildScrollView(
              child: allConditionsMet ? SellerLandingPage() : ToDoListSeller(),
            ),
            const    SellerTools() ,
            const Text(
              'Messages',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SingleChildScrollView(
              child:   FeedMain(),
            ),
          ];

          // Return different widgets based on condition
          return _widgetOptions.elementAt(allConditionsMet ? _selectedIndex : 0);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: AppColors.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Tools',
            backgroundColor: AppColors.primaryColor
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger),
            label: 'Messages',
            backgroundColor:AppColors.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Feed',
            backgroundColor: AppColors.primaryColor,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[500],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

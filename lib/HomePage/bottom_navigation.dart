import 'package:flutter/material.dart';
import 'package:hatbazarsample/HomePage/productPageBody.dart';

class BottomWidget extends StatefulWidget {
  const BottomWidget({Key? key}) : super(key: key);

  @override
  _BottomWidgetState createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    //body
    Expanded(child:SingleChildScrollView(
      child:ProductPageBody()
    )),
    Text(
      'News',
      style: optionStyle,
    ),
    Text(
      'Messages',
      style: optionStyle,
    ),
    Text(
      'Account',
      style: optionStyle,
    ),
    Text(
      'Notifications',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
            backgroundColor: Colors.purple,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.messenger),
            label: 'messages',
            backgroundColor: Colors.pink,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
            backgroundColor: Colors.blue,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[500],
        onTap: _onItemTapped,
      ),
    );
  }
}

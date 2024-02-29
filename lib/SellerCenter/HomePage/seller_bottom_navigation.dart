import 'package:flutter/material.dart';
import 'package:hatbazarsample/SellerCenter/HomePage/toDoListSeller.dart';

class SellerBottomNavigation extends StatefulWidget {
  const SellerBottomNavigation({super.key});

  @override
  _SellerBottomNavigationState createState() => _SellerBottomNavigationState();
}

class _SellerBottomNavigationState extends State<SellerBottomNavigation> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    //body
    SingleChildScrollView(
      child: ToDoListSeller(),
    ),
    Text(
      'Tools',
      style: optionStyle,
    ),
    Text(
      'Messages',
      style: optionStyle,
    ),

    Text(
      'Data',
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
            icon: Icon(Icons.settings),
            label: 'Tools',
            backgroundColor: Colors.purple,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.messenger),
            label: 'messages',
            backgroundColor: Colors.pink,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_exploration),
            label: 'Data',
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

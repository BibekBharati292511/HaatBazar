import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

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
                "Gmail",
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
          onTap: () {},
          leading: const Icon(
            Icons.inbox,
            color: Colors.black,
          ),
          trailing: const Text("99+"),
          title: const Text("Inbox"),
        ),
        ListTile(
          onTap: () {},
          leading: const Icon(
            Icons.star_border,
            color: Colors.black,
          ),
          title: const Text("Starred"),
        ),
        ListTile(
          onTap: () {},
          leading: const Icon(
            Icons.snooze,
            color: Colors.black,
          ),
          title: const Text("Snoozed"),
        ),
        ListTile(
          onTap: () {},
          leading: const Icon(
            Icons.label_important,
            color: Colors.black,
          ),
          title: const Text("Important"),
        ),
        ListTile(
          onTap: () {},
          leading: const Icon(
            Icons.inbox,
            color: Colors.black,
          ),
          title: const Text("Draft"),
        ),
        ListTile(
          onTap: () {},
          leading: const Icon(
            Icons.inbox,
            color: Colors.black,
          ),
          title: const Text("Sent"),
        ),
      ],
    );
  }
}

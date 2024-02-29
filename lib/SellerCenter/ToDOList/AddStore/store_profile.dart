import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';

import '../../../Utilities/ResponsiveDim.dart';
import '../../../Utilities/colors.dart';
import '../../../Widgets/smallText.dart';
import '../CompleteProfile/complete_profile_main.dart';

class StoreProfilePage extends StatefulWidget {
  const StoreProfilePage({super.key});

  @override
  State<StoreProfilePage> createState() => _StoreProfilePageState();
}

class _StoreProfilePageState extends State<StoreProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveStoreData() {
    // Retrieve store data from the text controllers
    String storeName = _nameController.text;
    String storeDescription = _descriptionController.text;

    // Create a map or object to store the store data
    Map<String, String> storeData = {
      'name': storeName,
      'description': storeDescription,
    };

    // Pass the store data back to the previous screen using Navigator.pop()
    Navigator.pop(context, storeData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.backgroundColor,
        child: Column(
          children: [
            AppBar(
              backgroundColor: AppColors.backgroundColor,
              title: BigText(text: "Store Profile"),
            ),
            SizedBox(height: ResponsiveDim.height5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Store Name:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: "Enter store name",
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Description:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextField(
                    maxLines: 3,
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: "Enter store description",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _saveStoreData,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

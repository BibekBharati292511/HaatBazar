import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hatbazarsample/Model/ProfileCompletionTracker.dart';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:hatbazarsample/main.dart';
import 'package:http/http.dart' as http;
import '../../../Model/UserData.dart';
import '../../../Utilities/ResponsiveDim.dart';
import '../../../Utilities/colors.dart';
import '../../../Widgets/alertBoxWidget.dart';
import '../../../Widgets/bigText.dart';

class EditName extends StatefulWidget {
  const EditName({super.key});

  @override
  State<EditName> createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  bool _hasErrors = true;


  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _firstNameController = TextEditingController(text: userDataJson['firstName'] ?? '');
    _lastNameController = TextEditingController(text: userDataJson['lastName'] ?? '');
  }
  void _validateForm() {
    setState(() {
      _hasErrors = _validateFirstName(_firstNameController.text) != null ||
          _validateLastName(_lastNameController.text) != null;
    });
  }
  Future<void> changeUserName(String firstName,String lastName) async {
    final url = Uri.parse("${serverBaseUrl}user/changeUserInfo");

    try {
      final response = await http.put(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, Object>{
          "firstName":firstName,
          "lastName":lastName,
          "email": userEmail!,
        }),
      );
      if (!context.mounted) return;
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == 'Error') {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext dialogContext) {
              return MyAlertDialog(
                title: 'Error',
                content: responseData['message'],
              );
            },
          );
        }

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return MyAlertDialog(
              title: 'Success',
              content: "New Name set successfully.",
                actions: [
                TextButton(
                  onPressed: () async {
                    await UserDataService.fetchUserData(userToken!).then((userData) {
                      userDataJson = jsonDecode(userData);
                      bytes=base64Decode(userDataJson["image"]);
                    });
                    Navigator.pushNamed(context, 'sellerHomePage');
                    {
                      await ProfileCompletionTracker.profileCompletionTracker();

                      print(isProfileCompleted);
                    }
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(title: 'Error', content: 'Failed to change Name: $e');
        },
      );
    }
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            AppBar(
              backgroundColor: AppColors.backgroundColor,
              automaticallyImplyLeading: false,
              elevation: 0,
              title: Container(
                padding: EdgeInsets.only(left: ResponsiveDim.radius6),
                alignment: Alignment.centerLeft,
                child: BigText(
                  text: "Edit Name",
                  color: AppColors.primaryColor,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back), // Back button icon
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: AppColors.primaryButtonColor,
              ),
              actions: [
                TextButton(
                  onPressed:_hasErrors
                      ? null
                      : () async {
                    String firstName = _firstNameController.text;
                    String lastName = _lastNameController.text;
                    await changeUserName(firstName, lastName);
                  },

                  child: Text(
                    "Save",
                    style: TextStyle(
                      fontSize: ResponsiveDim.bigFont,
                      color: _hasErrors ? Colors.grey[300] : Colors.red,
                    ),
                  ),
                )
              ],
              iconTheme: IconThemeData(
                size: ResponsiveDim.height45,
                color: AppColors.primaryButtonColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                  labelText: 'First Name',
                  hintText: 'Enter Your Name',
                ),
                validator: _validateFirstName,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (_) => _validateForm(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                  labelText: 'Last Name',
                  hintText: 'Enter Your Name',
                ),
                validator: _validateLastName,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (_) => _validateForm(),
              ),
            ),

          ],
        ),
      ),
    );
  }
  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'First name is required';
    } else if (value.length > 15) {
      return 'First name should not exceed 15 characters';
    } else if (value.startsWith(RegExp(r'[0-9]'))) {
      return 'First name should not start with a number';
    } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'First name should not contain special characters or spaces';
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Last name is required';
    } else if (value.length > 15) {
      return 'Last name should not exceed 15 characters';
    } else if (value.startsWith(RegExp(r'[0-9]'))) {
      return 'Last name should not start with a number';
    } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Last name should not contain special characters or spaces';
    }
    return null;
  }
}

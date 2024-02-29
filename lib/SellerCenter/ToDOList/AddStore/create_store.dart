import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hatbazarsample/main.dart';
import 'package:http/http.dart' as http;

import '../../../Utilities/ResponsiveDim.dart';
import '../../../Utilities/constant.dart';
import '../../../Widgets/alertBoxWidget.dart';
import '../../../Widgets/loginBackgroundImage.dart';
import '../../../Widgets/progress_indicator.dart';

class CreateStore extends StatefulWidget {
  const CreateStore({Key? key});

  @override
  State<CreateStore> createState() => _CreateStoreState();
}

class _CreateStoreState extends State<CreateStore> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool _hasErrors=false;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> createStore(String storeName, String description) async {
    final url = Uri.parse("${serverBaseUrl}store/add");

    try {
      final response = await http.post(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, Object>{
          "name": storeName,
          "description": description,
          "token":userToken!,
          "type":{"id":storeTypeId},

        }),
      );

      if (response.statusCode == 200) {
        // Decode the response JSON
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check if the response indicates that the user already exists
        if (responseData['status'] == 'Error') {
          if (!context.mounted) return;
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
        } else {
          if (!context.mounted) return;
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext dialogContext) {
              return MyAlertDialog(
                title: 'Success',
                content: "Store Created Successfully",
                actions: [
                  TextButton(
                    onPressed: () {
                      isStoreProfileCompleted=true;
                      Navigator.pushNamed(context, 'addStore');
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            },
          );
          nameController.clear();
          descriptionController.clear();
        }
      } else {
        // Handle other status codes (e.g., 400, 500) here
        throw Exception('Failed to create store: ${response.body}');
      }
    } catch (e) {
      // Handle network errors here
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(title: 'Error', content: 'Failed to create store: $e');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const LoginBackgroundImage(),
            Center(
              child: buildLoginContainer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoginContainer() {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.only(top: 160),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(42)),
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.white)),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: buildLoginForm(),
      ),
    );
  }

  Widget buildLoginForm() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context); // Navigate back
                  },
                ),
                Expanded(
                  child: Text(
                    'Create Store',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ResponsiveDim.font24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "poppins",
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveDim.height20),
            const ProgressIndicators(currentPage: 2, totalPages: 2),
            SizedBox(height: ResponsiveDim.height15),
            buildTextField(
              'Store Name',
              TextInputType.name,
              nameController,
              _validateStoreName,
            ),
            buildDescriptionField(_validateDescription),
            buildCreateStoreButton(),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String hintText,
      TextInputType keyboardType,
      TextEditingController controller,
      String? Function(String?)? validator,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 90.0, vertical: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: validator != null ? validator(controller.text) : null,
            fillColor: Colors.transparent,
            filled: true,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDescriptionField(
      String? Function(String?)? validator
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 90.0, vertical: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextFormField(
          controller: descriptionController,
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          validator:validator,
          decoration: InputDecoration(
            hintText: 'Description',
            errorText: validator != null ? validator(descriptionController.text) : null,
            fillColor: Colors.transparent,
            filled: true,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateStoreName(String? value) {
    // Update validation and set _hasErrors accordingly
    if (value == null || value.isEmpty) {
      setState(() {
        _hasErrors = true;
      });
      return 'Store name is required';
    } else if (value.startsWith(RegExp(r'[0-9]'))) {
      setState(() {
        _hasErrors = true;
      });
      return 'Store name should not start with a number';
    } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value)) {
      setState(() {
        _hasErrors = true;
      });
      return 'Store name should not contain special characters';
    } else {
      setState(() {
        _hasErrors = false;
      });
    }
    return null;
  }

  String? _validateDescription(String? value) {
    // Update validation and set _hasErrors accordingly
    if (value == null || value.isEmpty) {
      setState(() {
        _hasErrors = true;
      });
      return 'Description is required';
    } else if (value.length < 10) {
      setState(() {
        _hasErrors = true;
      });
      return 'Description should be at least 10 characters';
    } else {
      setState(() {
        _hasErrors = false;
      });
    }
    return null;
  }
  Widget buildCreateStoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.07,
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
        child: ElevatedButton(
          onPressed: _hasErrors // Disable the button if there are errors
              ? null
              : () async {
            String storeName = nameController.text;
            String description = descriptionController.text;
            // Proceed with store creation
            await createStore(storeName, description);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF003F12),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          child: const Text(
            'Create Store',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}

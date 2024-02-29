import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:hatbazarsample/Utilities/iconButtonWithText.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Model/ProfileCompletionTracker.dart';
import '../../../Model/UserData.dart';
import '../../../Utilities/ResponsiveDim.dart';
import '../../../Widgets/alertBoxWidget.dart';
import '../../../Widgets/bigText.dart';
import 'package:http/http.dart' as http;

import '../../../main.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _image;
  late String base64Image;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Convert selected image to byte array
      List<int> imageBytes = await _image!.readAsBytes();

      // Encode the byte array as a Base64 string
       base64Image = base64Encode(imageBytes);

      print("Base64 Image: $base64Image");
    }
  }
  Future<void> _saveImage( String base64Image) async {
    final url = Uri.parse("${serverBaseUrl}user/changeUserInfo");

    try {
      final response = await http.put(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, Object>{
          "email": userEmail!,
          "image": base64Image,
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
        else{
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return MyAlertDialog(
              title: 'Success',
              content: "Image set successfully.",
              actions: [
                TextButton(
                  onPressed: () async {
                    await ProfileCompletionTracker.profileCompletionTracker();
                    await UserDataService.fetchUserData(userToken!).then((
                        userData) {
                      userDataJson = jsonDecode(userData);
                      bytes=base64Decode(userDataJson["image"]);
                    });
                    Navigator.pushNamed(context, 'sellerHomePage');
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      }
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(title: 'Error', content: 'Failed to set image: $e');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isImageSelected = _image != null;
    print(_image);
    if (_image != null) {
      print("Selected Image Path: ${_image!.path}");
    }
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            backgroundColor: AppColors.backgroundColor,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Container(
              padding: EdgeInsets.only(left: ResponsiveDim.radius6),
              alignment: Alignment.centerLeft,
              child: BigText(
                text: "Add Image",
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
                onPressed: isImageSelected
                    ? () async {
                  await _saveImage( base64Image);
                }
                    : null,
                child: Text(
                  "Save",
                  style: TextStyle(
                    fontSize: ResponsiveDim.bigFont,
                    color: isImageSelected ? Colors.red : Colors.grey[300],
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
            padding: EdgeInsets.symmetric(horizontal: ResponsiveDim.width10, vertical: ResponsiveDim.height45),
            child: Column(
              children: <Widget>[
                _image != null
                    ? Image.file(
                  _image!,
                  height: ResponsiveDim.height250,
                )
                    : const Placeholder(
                  fallbackHeight: 200,
                  fallbackWidth: double.infinity,
                ),
                SizedBox(height: ResponsiveDim.height20),
                IconButtonWithText(
                  onPressed: _getImage,
                  icon: Icons.photo_size_select_actual_outlined,
                  buttonText: const Text("Select Image"),
                  textColor: Colors.white,
                  height: 50,
                  iconColor: Colors.white,
                  width: ResponsiveDim.screenWidth,
                ),
                // IconAndWidget(icon: Icons.photo_size_select_actual_outlined, text: "Select Image", iconColor: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/AgroTechnicians/ToDoTechnician/setting_services.dart';
import 'package:hatbazarsample/AgroTechnicians/ToDoTechnician/settings_dto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Utilities/iconButtonWithText.dart';
import 'package:hatbazarsample/Widgets/alertBoxWidget.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';

import '../../main.dart';

class AddCertificatePage extends StatefulWidget {
  late int id;
   AddCertificatePage({super.key,required this.id});

  @override
  _AddCertificatePageState createState() => _AddCertificatePageState();
}

class _AddCertificatePageState extends State<AddCertificatePage> {
final TechnicianSettingServices _services =new TechnicianSettingServices();

  File? _selectedImage;
  late String base64Image;
     String certificateUrl="";

late Map<String, dynamic> fieldsToUpdate ={};

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final source = await _chooseImageSource(context);

    if (source != null) {
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });

        final imageBytes = await _selectedImage!.readAsBytes();
        base64Image = base64Encode(imageBytes);

        print("Base64 Image: $base64Image");
      }
    }
  }

  Future<ImageSource?> _chooseImageSource(BuildContext context) async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Gallery"),
                onTap: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("Camera"),
                onTap: () {
                  Navigator.pop(context, ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadToCloudinary(BuildContext context) async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select or capture an image before uploading.")),
      );
      return;
    }

    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/du6pugg6x/upload');
      final request = http.MultipartRequest("POST", url);
      request.fields['upload_preset'] = 'k9wxyzpn';
      request.files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await http.Response.fromStream(response);
        final result = json.decode(responseBody.body);
        _showSuccessDialog(context, "Certificate uploaded successfully");
         certificateUrl=result['secure_url'];
        await _services.updateTechnicianSettings(widget.id, fieldsToUpdate = {
          'certificateImage': certificateUrl,
        }, context);
        print(certificateUrl);
      } else {
        throw Exception("Failed to upload to Cloudinary");
      }
    } catch (e) {
      _showErrorDialog(context, "Error uploading certificate. Please try again.");
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MyAlertDialog(
          title: 'Success',
          content: message,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'technicianProfile');
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return MyAlertDialog(
          title: 'Error',
          content: message,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isImageSelected = _selectedImage != null;

    return Scaffold(
      body: Column(
        children: [
          AppBar(
            backgroundColor: AppColors.backgroundColor,
            elevation: 0,
            title: Container(
              padding: EdgeInsets.only(left: ResponsiveDim.radius6),
              alignment: Alignment.centerLeft,
              child: BigText(
                text: "Add Certificate",
                color: AppColors.primaryColor,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: AppColors.primaryButtonColor,
            ),
            actions: [
              TextButton(
                onPressed: isImageSelected ? () => _uploadToCloudinary(context) : null,
                child: Text(
                  "Upload",
                  style: TextStyle(
                    fontSize: ResponsiveDim.bigFont,
                    color: isImageSelected ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveDim.width10,
              vertical: ResponsiveDim.height45,
            ),
            child: Column(
              children: <Widget>[
                if (_selectedImage != null)
                  Image.file(
                    _selectedImage!,
                    height: ResponsiveDim.height250,
                  )
                else
                  const Placeholder(
                    fallbackHeight: 200,
                    fallbackWidth: double.infinity,
                  ),
                SizedBox(height: ResponsiveDim.height20),
                IconButtonWithText(
                  onPressed: _pickImage,
                  icon: Icons.photo_size_select_actual_outlined,
                  buttonText: const Text("Pick or Capture Image"),
                  height: 50,
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  width: ResponsiveDim.screenWidth,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

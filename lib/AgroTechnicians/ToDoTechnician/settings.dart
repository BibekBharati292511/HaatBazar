import 'package:flutter/material.dart';
import 'package:hatbazarsample/AgroTechnicians/ToDoTechnician/setting_services.dart';
import 'package:hatbazarsample/AgroTechnicians/ToDoTechnician/settings_dto.dart';
import 'package:hatbazarsample/main.dart';
import 'package:intl/intl.dart'; // For time formatting
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class TechnicianSettingsPage extends StatefulWidget {
  @override
  _TechnicianSettingsPageState createState() => _TechnicianSettingsPageState();
}

class _TechnicianSettingsPageState extends State<TechnicianSettingsPage> {
  late  String certificateUrl;
  final TechnicianSettingServices _service = TechnicianSettingServices();
  final TextEditingController _chargeController = TextEditingController();
  String? _selectedCategory;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  File? _certificateImage;
  bool isFormValid = false;
  late final TechnicianSettings Settings;

  @override
  void initState() {
    super.initState();
    _chargeController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      isFormValid = _selectedCategory != null &&
          _chargeController.text.isNotEmpty &&
          startTime != null &&
          endTime != null &&
          _certificateImage != null;
    });
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
      _validateForm();
    }
  }

  Future<void> _pickCertificate(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _certificateImage = File(pickedFile.path);
      });
      _validateForm();
    }
  }

  Future<void> _uploadCertificate(BuildContext context) async {
    if (_certificateImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an image before uploading.")),
      );
      return;
    }

    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/du6pugg6x/upload');
      final request = http.MultipartRequest("POST", url);
      request.fields['upload_preset'] = 'k9wxyzpn';
      request.files.add(await http.MultipartFile.fromPath('file', _certificateImage!.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await http.Response.fromStream(response);
        final result = json.decode(responseBody.body);
         certificateUrl=result['secure_url'];
        print(certificateUrl);
       // _showSuccessDialog(context, "Certificate uploaded successfully");
      } else {
        throw Exception("Failed to upload to Cloudinary");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading certificate. Please try again.")),
      );
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                isAddSettingsCompleted=true;
                addTechnicianStatsChecker();
               _service.createTechnicianSettings(Settings, context);
               _service.doesTechnicianSettingExist(token, context);
                Navigator.pushNamed(context, 'technicianHome');
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Function to print all available data
  void _printData() {
    print("Selected Category: ${_selectedCategory ?? 'None'}");
    print("Charge per hour: ${_chargeController.text}");
    print("Start Time: ${startTime?.format(context) ?? 'Not Set'}");
    print("End Time: ${endTime?.format(context) ?? 'Not Set'}");
    print("Certificate Image: ${_certificateImage != null ? 'Uploaded' : 'Not Uploaded'}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Technician Settings", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Navigate back
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Technician Category Section
            Text(
              "Select your technician category",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: "JTA",
                  child: Text("JTA"),
                ),
                DropdownMenuItem(
                  value: "Veterinary Doctor",
                  child: Text("Veterinary Doctor"),
                ),
                DropdownMenuItem(
                  value: "Soil Expert",
                  child: Text("Soil Expert"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value as String?;
                });
                _validateForm(); // Re-validate after setting category
              },
              hint: Text("Select Category"),
            ),
            SizedBox(height: 16),

            // Charge Per Hour Section
            Text(
              "Set your charge per hour",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _chargeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Charge per hour",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Working Hours Section
            Text(
              "Set your working hours",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    buttonText: startTime != null
                        ? "Start Time: ${startTime!.format(context)}"
                        : "Start Time",
                    onPressed: () => _selectTime(context, true),
                    width: ResponsiveDim.screenWidth,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    buttonText: endTime != null
                        ? "End Time: ${endTime!.format(context)}"
                        : " End Time",
                    onPressed: () => _selectTime(context, false),
                    width: ResponsiveDim.screenWidth,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            // Certificate Section
            SizedBox(height: 16),
            Text(
              "Upload Technician Certificate",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            if (_certificateImage != null)
              Image.file(
                _certificateImage!,
                height: 200,
                fit: BoxFit.cover,
              )
            else
              IconButton(
                onPressed: () => _pickCertificate(context),
                icon: Icon(Icons.add_a_photo, size: 50),
              ),

            // Save Button
            SizedBox(height: 16),
            CustomButton(
              buttonText: "Save",
              onPressed: isFormValid ? () async{
               await _uploadCertificate(context); // Upload certificate
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Settings saved successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
                _printData();
               String formatTimeOfDay(TimeOfDay time) {

                 final hour = (time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod).toString().padLeft(2, '0');
                 final minute = time.minute.toString().padLeft(2, '0');
                 final period = time.period == DayPeriod.am ? 'AM' : 'PM';

                 return '$hour:$minute $period';
               }
               final formattedStartTime = formatTimeOfDay(startTime!); // "11:22 PM"
               final formattedEndTime = formatTimeOfDay(endTime!);
                double charge=double.parse(_chargeController.text);
                 Settings = TechnicianSettings(
                  category: _selectedCategory!,
                  chargePerHour: charge,
                  startTime: formattedStartTime,
                  endTime: formattedEndTime,
                  certificateImage: certificateUrl,
                  userToken: token,
                );
                _showSuccessDialog(context, "Data updated sucessfully");
              } : (){
                print("Error");
              },
              width: ResponsiveDim.screenWidth,
              color: isFormValid ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

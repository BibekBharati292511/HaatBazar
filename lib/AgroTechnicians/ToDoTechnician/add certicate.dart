import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class UploadCertificate extends StatelessWidget {
  final File certificateFile;

  UploadCertificate({required this.certificateFile});

  Future<void> _uploadToCloudinary(BuildContext context, File image) async {
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/du6pugg6x/upload');
      final request = http.MultipartRequest("POST", url);
      request.fields['upload_preset'] = 'k9wxyzpn';
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          image.path,
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await http.Response.fromStream(response);
        final result = json.decode(responseBody.body);
        print("Uploaded to Cloudinary: ${result['secure_url']}");

        // Show success dialog
        _showSuccessDialog(context);
      } else {
        throw Exception("Failed to upload to Cloudinary");
      }
    } catch (e) {
      // Handle errors here
      print("Error: $e");
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("The certificate has been successfully uploaded."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Certificate"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _uploadToCloudinary(context, certificateFile); // Upload the file
          },
          child: Text("Upload Certificate"),
        ),
      ),
    );
  }
}

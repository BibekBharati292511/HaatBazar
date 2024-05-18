
import 'package:get/get.dart';
import 'package:hatbazarsample/AgroTechnicians/ToDoTechnician/settings_dto.dart';
import 'package:hatbazarsample/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

import '../../Utilities/constant.dart';

class TechnicianSettingServices {

  Future<TechnicianSettings?> createTechnicianSettings(
      TechnicianSettings settings, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('${serverBaseUrl}appointment/technician-settings/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(settings.toJson()),
      );

      if (response.statusCode == 200) {
        isAddSettingsCompleted=true;
        addTechnicianStatsChecker();

        return TechnicianSettings.fromJson(jsonDecode(response.body));
      } else {
        showErrorDialog(context, 'Failed to create technician settings');
        return null;
      }
    } catch (error) {
      showErrorDialog(context, 'Error: $error');
      return null;
    }
  }
  Future<TechnicianSettings?> updateTechnicianSettings(
      int id, Map<String, dynamic> fieldsToUpdate, BuildContext context) async {
    try {
      final response = await http.put(
        Uri.parse('${serverBaseUrl}appointment/technician-settings/update?id=$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(fieldsToUpdate),
      );

      if (response.statusCode == 200) {
        return TechnicianSettings.fromJson(jsonDecode(response.body));
      } else {
        showErrorDialog(context, 'Failed to update technician settings');
        return null;
      }
    } catch (error) {
      showErrorDialog(context, 'Error: $error');
      return null;
    }
  }

  Future<List<TechnicianSettings>?> getAllTechnicianSettings(
      BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('${serverBaseUrl}appointment/technician-settings/all'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => TechnicianSettings.fromJson(json)).toList();
      } else {
        showErrorDialog(context, 'Failed to fetch technician settings');
        return null;
      }
    } catch (error) {
      showErrorDialog(context, 'Error: $error');
      return null;
    }
  }

  Future<TechnicianSettings?> findByUserToken(
      String userToken, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${serverBaseUrl}appointment/technician-settings/userToken?userToken=$userToken',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return TechnicianSettings.fromJson(jsonDecode(response.body));
      } else {
        showErrorDialog(context, 'No technician settings found for this token');
        return null;
      }
    } catch (error) {
      showErrorDialog(context, 'Error: $error');
      return null;
    }
  }

  Future<bool> doesTechnicianSettingExist(
      String userToken, BuildContext context) async {
    print("In technician checker");
    try {
      final response = await http.get(
        Uri.parse(
          '${serverBaseUrl}appointment/technician-settings/existByUserToken?userToken=$userToken',
        ),
        headers: {'Content-Type': 'application/json'},

      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        if(responseData['tracker']==true){
          print("${isAddSettingsCompleted}running here bro");
          isAddSettingsCompleted=true;
          addTechnicianStatsChecker();
        }
        print("in here heaserfd");
        print(responseData['tracker']);
        return responseData['tracker'];

      }
      else {
        showErrorDialog(context, 'Failed to check existence');
        return false;
      }
    } catch (error) {
      showErrorDialog(context, 'Error: $error');
      return false;
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

}

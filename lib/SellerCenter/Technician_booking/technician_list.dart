import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/SellerCenter/Technician_booking/profile_Image_view.dart';
import 'package:hatbazarsample/Widgets/profile_image_widget.dart';
import 'package:http/http.dart' as http;
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';
import 'package:hatbazarsample/Widgets/smallText.dart';
import 'package:hatbazarsample/Model/UserAddress.dart';
import 'package:hatbazarsample/Model/UserData.dart';
import 'package:hatbazarsample/Utilities/constant.dart';
import '../../AgroTechnicians/ToDoTechnician/settings_dto.dart';
import 'view_profile_technician.dart';

class TechnicianList extends StatefulWidget {
  const TechnicianList({Key? key}) : super(key: key);

  @override
  _TechnicianListState createState() => _TechnicianListState();
}

class _TechnicianListState extends State<TechnicianList> {
  List<TechnicianSettings>? technicians;

  @override
  void initState() {
    super.initState();
    fetchTechnicians();
  }

  Future<void> fetchTechnicians() async {
    final response = await http.get(Uri.parse('${serverBaseUrl}appointment/technician-settings/all'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        technicians = jsonData.map((json) => TechnicianSettings.fromJson(json)).toList();
      });
    } else {
      showErrorDialog(context, 'Failed to fetch technicians');
    }
  }

  Future<Map<String, dynamic>> fetchTechnicianData(String userToken) async {
    final userData = await UserDataService.fetchUserData(userToken);
    final technicianDataJson = jsonDecode(userData);

    final userAddress = await UserAddressService.fetchUserAddress(technicianDataJson["id"]);
    final technicianAddressJson = jsonDecode(userAddress);
    final technicianAddress = technicianAddressJson["address"];

    final technicianBytes = base64Decode(technicianDataJson["image"] ?? '');

    return {
      'data': technicianDataJson,
      'address': technicianAddress,
      'image': technicianBytes,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BigText(text: "Book Technician", color: Colors.white),
        backgroundColor: AppColors.primaryColor,
      ),
      body: technicians == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: technicians!.length,
        itemBuilder: (context, index) {
          final technician = technicians![index];

          return FutureBuilder<Map<String, dynamic>>(
            future: fetchTechnicianData(technician.userToken ?? ''),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final technicianInfo = snapshot.data!;
              final technicianBytes = technicianInfo['image'];
              final technicianDataJson = technicianInfo['data'];
              final technicianAddress = technicianInfo['address'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewProfileTechnician(
                        technicianToken: technician.userToken,
                        technicianDataJson: technicianDataJson,
                        technicianBytes: technicianBytes,
                        technicianAddress: technicianAddress,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,

                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(width: 10,),
                      technicianBytes != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: ViewProfileImage(
                          width: 90,
                          height: 90,
                          bytes: technicianBytes,
                        ),
                      )
                          : Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,right: 2,left: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BigText(text: '${technicianDataJson["firstName"]} ${technicianDataJson["lastName"]}', weight: FontWeight.bold,size: 20,),
                              BigText(text: '${technician.category}', weight: FontWeight.bold,size: 20,),
                              SmallText(text: 'Working hours: ${technician.startTime} - ${technician.endTime}',color: Colors.black,),
                              SmallText(text: 'Charge: Rs ${technician.chargePerHour} /hour',color: Colors.black,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hatbazarsample/AgroTechnicians/ToDoTechnician/add_certificate.dart';
import 'package:hatbazarsample/AgroTechnicians/ToDoTechnician/charge_per_hour.dart';
import 'package:hatbazarsample/AgroTechnicians/ToDoTechnician/techinican_category.dart';
import 'package:hatbazarsample/AgroTechnicians/ToDoTechnician/working_hour.dart';
import 'package:hatbazarsample/Utilities/iconButtonWithText.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';
import 'package:hatbazarsample/Widgets/smallText.dart';
import 'package:hatbazarsample/main.dart';
import 'package:popup_banner/popup_banner.dart';

import '../Utilities/ResponsiveDim.dart';
import '../Utilities/colors.dart';
import '../Widgets/profile_image_widget.dart';
import 'ToDoTechnician/setting_services.dart';
import 'ToDoTechnician/settings_dto.dart';

class ProfileTechnician extends StatefulWidget {
  const ProfileTechnician({super.key});

  @override
  State<ProfileTechnician> createState() => _ProfileTechnicianState();
}

class _ProfileTechnicianState extends State<ProfileTechnician> {
  TechnicianSettings? _technicianSettings;
  final TechnicianSettingServices _service = TechnicianSettingServices();
  void loadSettings() async{
    final technicianSettings = await _service.findByUserToken(token, context);
    setState(() {
      _technicianSettings = technicianSettings;
    });
    print(_technicianSettings?.id);
  }
  @override
  void initState(){
    super.initState();
    loadSettings();

  }
  @override
  Widget build(BuildContext context) {
    bytes=base64Decode(userDataJson["image"]??'');

    return  Scaffold(
      appBar: AppBar(
        title: BigText(text: "Profile",color: Colors.white,),
        backgroundColor: AppColors.primaryColor,
        leading: GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, 'technicianHome');
          },
          child: Icon(Icons.arrow_back,color: Colors.white,),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ResponsiveDim.height10),
             // Image.asset("https://res.cloudinary.com/du6pugg6x/image/upload/v1715103888/images/mtzeh8kcutd7sebyycav.jpg"),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ProfileImage(bytes:bytes,width: 200,height: 200,),
                        SizedBox(width: ResponsiveDim.width15,),
                        Text("    ",),
                        // Icon(Icons.edit,color: Colors.red,)
                      ],
                    ),
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  // Container(
                  // width: 250,
                  // height:250 ,
                  // child: ClipRRect(
                  //   borderRadius: BorderRadius.circular(200),
                  //   child: Image.network(
                  //     'https://res.cloudinary.com/du6pugg6x/image/upload/v1715103888/images/mtzeh8kcutd7sebyycav.jpg',
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  // ),
                  //       SizedBox(width: ResponsiveDim.width15,),
                  //       Text("    ",),
                  //       // Icon(Icons.edit,color: Colors.red,)
                  //     ],
                  //   ),
                    SizedBox(height: ResponsiveDim.height5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BigText(text: '${userDataJson["firstName"]} ${userDataJson["lastName"]} ',weight: FontWeight.bold,),
                        SizedBox(width: ResponsiveDim.width15,),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context,'completeProfile');
                          },
                          child: Icon(Icons.edit,color: Colors.red,),
                        )
                      ],
                    ),
                    SizedBox(height: ResponsiveDim.height5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BigText(text: '${userDataJson["phone_number"]}'),
                        SizedBox(width: ResponsiveDim.width15,),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, "createSellerAccount");
                          },
                          child: Icon(Icons.edit,color: Colors.red,),
                        )
                      ],
                    ),
                    BigText(text: '${userDataJson["email"]}  ',size: ResponsiveDim.smallFont,),
                    SizedBox(height: ResponsiveDim.height5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${userAddress['cityDistrict']} ${userAddress['state']} ${userAddress['county']}'),
                        SizedBox(width: ResponsiveDim.width10,),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, 'mapScreen');
                          },
                          child: Icon(Icons.my_location,color: Colors.red,),
                        )
                      ],
                    ),
                    SizedBox(height: ResponsiveDim.height15),
                  ],
                ),
              ),
              BigText(text: "My settings"),
              SizedBox(height: ResponsiveDim.height15),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8)
                ),
                width: ResponsiveDim.screenWidth,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallText(text: "Category:  ${_technicianSettings?.category}",color: Colors.white,size: 20,),
                      GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SetTechnicianCategoryPage(id: _technicianSettings!.id!.toInt())));
                          },
                          child: Icon(Icons.edit,color: Colors.white,size: 35,)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: ResponsiveDim.height5),
              Container(
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8)
                ),
                width: ResponsiveDim.screenWidth,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallText(text: "Charge:  Rs ${_technicianSettings?.chargePerHour} /hour",color: Colors.white,size: 20,),
                      GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SetChargePerHourPage(id: _technicianSettings!.id!.toInt())));
                          },
                          child: Icon(Icons.edit,color: Colors.white,size: 35,)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: ResponsiveDim.height5),
              Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8)
                ),
                width: ResponsiveDim.screenWidth,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallText(text: "My certificate",color: Colors.white,size: 20,),
                      Row(
                        children: [
                          GestureDetector(
                            onTap:(){
                              PopupBanner(
                                context: context,
                                height: 600,
                                fit: BoxFit.contain,
                                images: [
                                  '${_technicianSettings?.certificateImage}'
                                ],
                                useDots: false,
                                onClick: (index) {
                                  debugPrint("CLICKED $index");
                                },
                              ).show();
                            },
                              child: Icon(Icons.remove_red_eye,color: Colors.white,size: 35)),
                          SizedBox(width: 15,),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddCertificatePage(id: _technicianSettings!.id!.toInt(),)));
                            },
                              child: Icon(Icons.edit,color: Colors.white,size: 35,)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: ResponsiveDim.height5),
              Container(
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8)
                ),
                width: ResponsiveDim.screenWidth,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallText(text: "Time:  ${_technicianSettings?.startTime} - ${_technicianSettings?.endTime}",color: Colors.white,size: 20,),
                      GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SetWorkingHoursPage(id: _technicianSettings!.id!.toInt())));
                          },
                          child: Icon(Icons.edit,color: Colors.white,size: 35,)),
                    ],
                  ),
                ),
              ),
              SizedBox(height:10 ,),
              CustomButton(buttonText: "Logout", onPressed: (){
                _logout(context);
              },width: ResponsiveDim.screenWidth,color: Colors.red,)


        
        
            ],
          ),
        ),
      ),
    );
  }
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushNamed(context, 'login'); // Logout
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}

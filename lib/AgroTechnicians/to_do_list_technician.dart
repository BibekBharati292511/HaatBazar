import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hatbazarsample/AgroTechnicians/ToDoTechnician/add_certificate.dart';
import 'package:hatbazarsample/AgroTechnicians/ToDoTechnician/charge_per_hour.dart';

import 'package:hatbazarsample/AgroTechnicians/button_container.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';


import '../Utilities/ResponsiveDim.dart';
import '../Utilities/colors.dart';
import '../main.dart';
import 'ToDoTechnician/settings.dart';

class ToDoListTechnician extends StatefulWidget {
  const ToDoListTechnician({super.key});

  @override
  State<ToDoListTechnician> createState() => _ToDoListTechnicianState();
}

class _ToDoListTechnicianState extends State<ToDoListTechnician> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: AppColors.backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: ResponsiveDim.width15),
          child: Column(
            children: [
              SizedBox(height: ResponsiveDim.height10),
              Text(
                "Complete these steps to start your journey",
                style: TextStyle(
                  fontSize: ResponsiveDim.font24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ResponsiveDim.height10),
              Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(ResponsiveDim.radius6)),
                    color: Colors.white,
                  ),
                  child: _buildTaskList()),
              SizedBox(height: ResponsiveDim.height15,),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(ResponsiveDim.radius6)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.facebook_outlined,
                          color: Colors.blue,
                        ),
                        SizedBox(width: ResponsiveDim.width10,),
                        Text(
                          "Join our facebook Group",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "poppins",
                            fontWeight: FontWeight.w400,
                            fontSize: ResponsiveDim.font24,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveDim.height10,),
                    const Text(
                      "Join facebook group of ‘Haat bazar ’for latest information updates, exclusive offers and be  a part of haat bazar community",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "poppins",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveDim.height15,),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(ResponsiveDim.radius6)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.email_rounded,
                          color: Colors.red,
                        ),
                        SizedBox(width: ResponsiveDim.width10,),
                        Text(
                          "Email us for Inquiry",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "poppins",
                            fontWeight: FontWeight.w400,
                            fontSize: ResponsiveDim.font24,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveDim.height10,),
                    const Text(
                      "Contact us at “hatbazarCustomerSupport@gmail.com” for help and support",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "poppins",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveDim.height20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return Column(
      children: [
        ButtonContainerTechnician(
          number: "1",
          text: "Complete Profile",
          tracker: isProfileCompleted,
          onTap: () {
            navigator?.pushNamed('completeProfile');
          },
        ),
        SizedBox(height: ResponsiveDim.height10),
        ButtonContainerTechnician(
          number: "2",
          text: "Add Address",
          tracker: isAddAddressCompleted,
          onTap: () {
            // Navigate to the Address screen
            Navigator.pushNamed(context, 'mapScreen');
          },
        ),
        SizedBox(height: ResponsiveDim.height10),
        ButtonContainerTechnician(
          number: "3",
          text: "Add Work Detail",
          tracker: isAddSettingsCompleted,
          onTap: () {
            isUploadingToCloudinary=true;
            // Navigate to the Certificate screen
           Navigator.push(context, MaterialPageRoute(builder: (context)=>TechnicianSettingsPage()));
          },
        ),
        SizedBox(height: ResponsiveDim.height10),

      ],
    );
  }
}

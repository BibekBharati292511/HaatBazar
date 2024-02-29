
import 'package:flutter/material.dart';
import 'package:hatbazarsample/Widgets/smallText.dart';

import '../../../Utilities/ResponsiveDim.dart';
import '../../../Utilities/colors.dart';
import '../../../Widgets/bigText.dart';
import '../../../Widgets/profile_image_widget.dart';
import '../../../main.dart';

class ClickableContainer extends StatelessWidget {
  final Widget content;
  final VoidCallback onPressed;

  const ClickableContainer({super.key, required this.content, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(

        width: ResponsiveDim.screenWidth,
        margin: EdgeInsets.symmetric(horizontal: ResponsiveDim.width15),
        padding: EdgeInsets.all(ResponsiveDim.height5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveDim.radius6),
          color: Colors.white
        ),
        child: content,
      ),
    );
  }
}

class CompleteProfileMainSeller extends StatefulWidget {
  const CompleteProfileMainSeller({super.key});

  @override
  State<CompleteProfileMainSeller> createState() => _CompleteProfileMainSellerState();
}

class _CompleteProfileMainSellerState extends State<CompleteProfileMainSeller> {


  String firstName = userDataJson["firstName"];
  String lastName = userDataJson["lastName"];
  String userMail = userDataJson["email"];
  String? phoneNumber =userDataJson["phone_number"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.backgroundColor,
        child: Column(
          children: [
            Container(
              height: ResponsiveDim.height5,
              color: AppColors.backgroundColor,
            ),
            //header
            AppBar(
              backgroundColor: AppColors.backgroundColor,
              automaticallyImplyLeading: false,
              elevation: 0,
              title: Container(
                padding: EdgeInsets.only(left: ResponsiveDim.radius6),
                alignment: Alignment.centerLeft,
                child: BigText(
                  text: "Add Profile",
                  color: AppColors.primaryColor,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back), // Back button icon
                onPressed: () {
                  Navigator.of(context).pop(); // Navigate back when back button is pressed
                },
                color: AppColors.primaryButtonColor,
              ),
              iconTheme: IconThemeData(
                size: ResponsiveDim.height45,
                color: AppColors.primaryButtonColor,
              ),
            ),
            Container(
              height: ResponsiveDim.height10,
              color: AppColors.backgroundColor,
            ),
            SizedBox(height: ResponsiveDim.height5),
            Container(
              width: ResponsiveDim.screenWidth,
              margin: EdgeInsets.symmetric(horizontal: ResponsiveDim.width15),
              padding: EdgeInsets.all(ResponsiveDim.height15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveDim.radius6),
                color: Colors.white,
              ),
              child: BigText(text: "Profile Information"),
            ),
            SizedBox(height: ResponsiveDim.height10),
            ClickableContainer(
              onPressed: () {
                Navigator.pushNamed(context, "editName");
                //navigator?.pushNamed("editName");
              },
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BigText(text: "Name", weight: FontWeight.bold, color: Colors.black38),
                  SizedBox(height: ResponsiveDim.height5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallText(text: "$firstName $lastName", size: ResponsiveDim.font24, color: Colors.black),
                      const Icon(Icons.arrow_forward_ios_outlined)
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveDim.height10),
            ClickableContainer(
              onPressed: () {

              },
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BigText(text: "Login Email Address", weight: FontWeight.bold, color: Colors.black38),
                  SizedBox(height: ResponsiveDim.height5),
                  Row(
                    children: [
                      Expanded(
                        child: SmallText(
                          text: userMail,
                          size: 18,
                          color: Colors.black,
                          overFlow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_outlined)
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveDim.height10),
            ClickableContainer(
              onPressed: () {
                Navigator.pushNamed(context, "createSellerAccount");
              },
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BigText(text: "Phone Number", weight: FontWeight.bold, color: Colors.black38),
                  SizedBox(height: ResponsiveDim.height5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallText(text: phoneNumber ?? "Set phone number", size: ResponsiveDim.font24, color: Colors.black),
                      const Icon(Icons.arrow_forward_ios_outlined)
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveDim.height10),
            ClickableContainer(
              onPressed: () {
                Navigator.pushNamed(context, "editProfileImage");
              },
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BigText(text: "Change profile "),
                  Row(
                    children: [
                      ProfileImage(bytes:bytes,width: 24,height: 24,),
                      const Icon(Icons.arrow_forward_ios_outlined)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

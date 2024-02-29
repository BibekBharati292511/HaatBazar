import 'package:flutter/material.dart';
import 'package:hatbazarsample/SellerCenter/HomePage/seller_bottom_navigation.dart';
import 'package:hatbazarsample/Widgets/profile_image_widget.dart';
import 'package:hatbazarsample/main.dart';

import '../../Model/ProfileCompletionTracker.dart';
import '../../Utilities/ResponsiveDim.dart';
import '../../Utilities/colors.dart';
import '../../Widgets/bigText.dart';

class SellerCenterMain extends StatefulWidget {
  const SellerCenterMain({super.key});

  @override
  State<SellerCenterMain> createState() => _SellerCenterMainState();

}


class _SellerCenterMainState extends State<SellerCenterMain> {
  @override
  void initState() {
    print("i am running");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ProfileCompletionTracker.profileCompletionTracker();
    });
  }
  @override
  Widget build(BuildContext context) {
   // print("height: " + MediaQuery.of(context).size.height.toString());
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 5,
            color:AppColors.backgroundColor,
          ),
          //header
          AppBar(
            backgroundColor: AppColors.backgroundColor,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row( // Use Row here instead of Expanded directly
              children: [
                ProfileImage(bytes:bytes),
                Expanded( // Place Expanded inside Row
                  child: Container(
                    padding: EdgeInsets.only(left: ResponsiveDim.radius6),
                    alignment: Alignment.centerLeft,
                    child:
                        BigText(
                          text: "Seller Center",
                          color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: ResponsiveDim.width10),
                child:Stack(
                  children: [
                    Icon(
                      Icons.notifications,
                      color: AppColors.primaryButtonColor,
                      size: ResponsiveDim.icon44,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: const Text(
                          '1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),

              ),

            ],
            iconTheme: IconThemeData(
              size: ResponsiveDim.height45,
              color: AppColors.primaryButtonColor,
            ),
          ),

          Container(
            height: 5,
            color: AppColors.backgroundColor,
          ),
          const Expanded(
            child: SellerBottomNavigation(),
          ),

        ],
      ),

    );
  }
}

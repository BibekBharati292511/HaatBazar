import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/AgroTechnicians/profile.dart';
import 'package:hatbazarsample/Profile.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/AddStore/add_store_main.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/CompleteProfile/edit_profile_image.dart';
import 'package:hatbazarsample/main.dart';
import '../Utilities/ResponsiveDim.dart';

class ProfileImage extends StatelessWidget {
  final Uint8List? bytes;
  final double? width;
  final double? height;

  const ProfileImage({super.key, required this.bytes,this.width,this.height});

  Widget getImageWidget() {
    if (bytes == null || bytes!.isEmpty) {
      // Return default image if bytes is null or empty
      return Image.asset(
        'assets/images/profile_image.png',
        width: ResponsiveDim.icon44,
        height: ResponsiveDim.icon44,
        fit: BoxFit.cover,
      );
    } else {
      // Return image from bytes if not empty
      return Image.memory(
        bytes!,
        width: width?? ResponsiveDim.icon44,
        height: height?? ResponsiveDim.icon44,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

      if (bytes == null || bytes!.isEmpty ) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageUpload(),
          ),
        );
      }
      else if (role=="Sellers"?!isAddStoreCompleted:!isTechnicianSetupCompleted) {
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent closing the dialog by tapping outside
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Incomplete Setup"),
              content: Text("You must complete the  setup to view your profile."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Dismiss the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddStorePage(), // Navigate to the Add Store page
                      ),
                    );
                  },
                  child: Text("Add Store"),
                ),
              ],
            );
          },
        );
      }
      else{
        (role=="Sellers")?
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileSeller(),
          ),
        ):  Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileTechnician(),
          ),
        );

      }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
          child: getImageWidget(),
        ),
      ),
    );
  }
}

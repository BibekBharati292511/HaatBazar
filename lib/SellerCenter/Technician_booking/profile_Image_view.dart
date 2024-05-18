import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../Utilities/ResponsiveDim.dart';

class ViewProfileImage extends StatelessWidget {
  final Uint8List? bytes;
  final double? width;
  final double? height;

  const ViewProfileImage({super.key, required this.bytes, this.width, this.height});

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
        width: width ?? ResponsiveDim.icon44,
        height: height ?? ResponsiveDim.icon44,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
    //  padding: const EdgeInsets.only(left :5,right: 5),
      padding: EdgeInsets.zero,
      child: Container(
        width: width ?? ResponsiveDim.icon44,
        height: height ?? ResponsiveDim.icon44,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(0),
        ),
        child: getImageWidget(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';

import '../Widgets/smallText.dart';
import 'colors.dart';

class IconButtonWithText extends StatelessWidget {
  final IconData? icon;
  final Widget? buttonText; // Updated to accept Widget
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double borderRadius;
  final Color iconColor;

  const IconButtonWithText({
    Key? key,
    this.icon,
    this.buttonText,
    required this.onPressed,
    this.width = 145,
    this.height = 45,
    this.iconColor=AppColors.primaryColor,
    this.backgroundColor = AppColors.primaryButtonColor,
    this.textColor = AppColors.primaryButtonColor,
    this.borderColor = AppColors.primaryButtonColor,
    this.borderRadius = 6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor),
        color: backgroundColor,
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: textColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (buttonText != null) buttonText!,
            if (buttonText != null && icon != null)
              SizedBox(width: ResponsiveDim.width10),
            if (icon != null) Icon(icon, size: ResponsiveDim.icon24,color: iconColor,),
          ],
        ),
      ),
    );
  }
}

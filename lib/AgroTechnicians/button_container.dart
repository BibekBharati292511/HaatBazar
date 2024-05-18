import 'package:flutter/material.dart';

import '../Utilities/ResponsiveDim.dart';
import '../Utilities/colors.dart';

class ButtonContainerTechnician extends StatelessWidget {
  final String number;
  final String text;
  final bool tracker;
  final Function() onTap;

  const ButtonContainerTechnician({
    required this.number,
    required this.text,
    required this.tracker,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          if (!tracker)
            Container(
              width: 30.0,
              height: ResponsiveDim.height45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Center(
                child: Text(
                  number,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          else
            Icon(Icons.check_circle, color: AppColors.primaryColor),
          SizedBox(width: ResponsiveDim.width10),
          Expanded(
            child: SizedBox(
              height: ResponsiveDim.height45,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: tracker ? Colors.green : Colors.red,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        fontSize: ResponsiveDim.smallFont,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "View",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: ResponsiveDim.width5),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

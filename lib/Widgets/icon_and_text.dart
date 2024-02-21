import 'package:flutter/cupertino.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Widgets/smallText.dart';

class IconAndWidget extends StatelessWidget {
  final IconData icon;
  final String text;

  final Color iconColor;
  const IconAndWidget({Key? key,
    required this.icon,
    required this.text,
    required this.iconColor,
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,color:iconColor,size: ResponsiveDim.icon24),

        const SizedBox(width:5),
        SmallText(text: text)
      ],
    );
  }
}

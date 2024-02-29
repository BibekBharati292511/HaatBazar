import 'package:flutter/cupertino.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';

class SmallText extends StatelessWidget {
  final Color? color;
  final String text;
  double size;
  double height;
  TextOverflow? overFlow;

  SmallText({super.key, this.color = const Color(0xffa9a6a6),
    required this.text,
    this.size = 0,
    this.height=1.2,
    this.overFlow=TextOverflow.ellipsis,

  });

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        overflow: overFlow,
        maxLines: 1,

        style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: size==0?ResponsiveDim.smallFont:size,
            color: color,

        )


    );
  }
}


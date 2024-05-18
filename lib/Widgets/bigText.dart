import 'package:flutter/cupertino.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';

class BigText extends StatelessWidget {
  final Color? color;
  final String text;
  final int? maxLine;
  double size;
  FontWeight? weight;
  final bool? wrap;

  TextOverflow overflow;

  BigText({super.key, this.color = const Color(0xFF332d2b),
    required this.text,
    this.maxLine,
    this.size = 0,
    this.overflow = TextOverflow.ellipsis,
    this.weight=FontWeight.w400,
    this.wrap=true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines:maxLine??1,
        text,
        overflow: overflow,
        softWrap:wrap,
        style: TextStyle(
            fontFamily: 'Poppins',
            color: color,
            fontSize: size==0?ResponsiveDim.bigFont:size,
            fontWeight: weight,

        )


    );
  }
}


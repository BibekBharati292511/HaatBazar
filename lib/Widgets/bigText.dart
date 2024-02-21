import 'package:flutter/cupertino.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';

class BigText extends StatelessWidget {
  final Color? color;
  final String text;
  double size;
  FontWeight? weight;
  final bool? wrap;

  TextOverflow overflow;

  BigText({Key? key, this.color = const Color(0xFF332d2b),
    required this.text,
    this.size = 0,
    this.overflow = TextOverflow.ellipsis,
    this.weight=FontWeight.w400,
    this.wrap=true,
  }) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
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


import 'package:flutter/material.dart';

class FeaturedGrowerWidget extends StatelessWidget {
  final String imageUrl;
  final String growerName;

  FeaturedGrowerWidget({
    required this.imageUrl,
    required this.growerName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            imageUrl,
            height: 120,
            width: 120,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 8),
        Text(
          growerName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

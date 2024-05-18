import 'package:flutter/material.dart';

import '../Utilities/ResponsiveDim.dart';
import 'individual_news.dart';

class NewsWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String newsId;


  NewsWidget({
    required this.imageUrl,
    required this.title,
    required this.description, required this.newsId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IndividualNewsPage(
              imageUrl: imageUrl,
              title: title,
              description: description,
              newsId: newsId,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: ResponsiveDim.width10, top: ResponsiveDim.height10, bottom: ResponsiveDim.height5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: "poppins",
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Text(
                              description,
                              style: TextStyle(fontSize: 16, fontFamily: "poppins"),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: ResponsiveDim.height10),

        ],
      ),
    );
  }
}

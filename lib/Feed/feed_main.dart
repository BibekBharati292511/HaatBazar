import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hatbazarsample/Feed/daily_price.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';
import 'package:hatbazarsample/Widgets/smallText.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Utilities/constant.dart';
import 'featured_sellers.dart';
import 'news.dart';

class FeedMain extends StatefulWidget {
  const FeedMain({Key? key}) : super(key: key);

  @override
  State<FeedMain> createState() => _FeedMainState();
}

class _FeedMainState extends State<FeedMain> {
  late Future<List<Map<String, dynamic>>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = fetchNews();
  }

  Future<List<Map<String, dynamic>>> fetchNews() async {
    final url = '${serverBaseUrl}fetchNews';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _newsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(), // Loading indicator
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: Connection Timed out please try again later'), // Error message
          );
        } else {
          final newsList = snapshot.data!;
          List<Map<String, String>> growers = [
            {"imageUrl": "https://t3.ftcdn.net/jpg/01/21/85/14/240_F_121851431_uxZfTTHyfVmv95jNDlKe0s4zYpZZ0fsl.jpg", "name": "Bibek Bharati"},
            {"imageUrl": "https://www.thefoodgroupmn.org/wp-content/uploads/2022/08/296TerraSuraPhotography-BigRiverFarms5x7-0984.jpg", "name": "Ravi Timilsina"},
          ];

          List<Widget> growerWidgets = [];

          // Populate the growerWidgets list
          for (var i = 0; i < growers.length; i++) {
            var grower = growers[i];
            growerWidgets.add(
              FeaturedGrowerWidget(
                imageUrl: grower["imageUrl"]!,
                growerName: grower["name"]!,
              ),
            );

            if (i < growers.length - 1) {
              growerWidgets.add(SizedBox(width: ResponsiveDim.width15));
            }
          }

          return SingleChildScrollView(
            child: Container(
              width: ResponsiveDim.screenWidth,
              color: AppColors.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BigText(text: "Featured Growers And Sellers"),
                    SizedBox(height: ResponsiveDim.height10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var growerWidget in growerWidgets) growerWidget,
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveDim.height15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BigText(text: "Daily agro price"),
                        CustomButton(
                          buttonText: 'View',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DailyAgroPrice(),
                              ),
                            );
                          },
                          width: 145,
                          height: 30,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveDim.height10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BigText(text: "Agro news"),
                      ],
                    ),
                    SizedBox(height: ResponsiveDim.height10),
                    for (final news in newsList)
                      NewsWidget(
                        imageUrl: news['imageUrl'] ?? '',
                        title: news['title'] ?? '',
                        description: news['description'] ?? '',
                        newsId: news['newsId']??'',
                      ),
                    SizedBox(height: ResponsiveDim.height15),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

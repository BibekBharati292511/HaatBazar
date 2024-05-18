import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:http/http.dart' as http;
import 'package:hatbazarsample/Widgets/bigText.dart';
import 'package:hatbazarsample/Widgets/smallText.dart';

import '../Utilities/colors.dart';

class IndividualNewsPage extends StatefulWidget {
  final String newsId;
  final String imageUrl;
  final String title;
  final String description;

  const IndividualNewsPage({
    Key? key,
    required this.newsId,
    required this.imageUrl,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  _IndividualNewsPageState createState() => _IndividualNewsPageState();
}

class _IndividualNewsPageState extends State<IndividualNewsPage> {
  late Future<String> _newsContentFuture;

  @override
  void initState() {
    super.initState();
    _newsContentFuture = fetchNewsContent();
  }

  Future<String> fetchNewsContent() async {
    final url = '${serverBaseUrl}fetchNews/${widget.newsId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['content'];
    } else {
      throw Exception('Failed to fetch news content');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<String>(
          future: _newsContentFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(), // Loading indicator
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'), // Error message
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontFamily: "poppins",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Image.network(
                      widget.imageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(snapshot.data ?? '', textAlign: TextAlign.left),
                  ),
                  SizedBox(height: 20),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text("Scarapped from European Union, 2024. I do not own any content presented above"),
                  ),
                  SizedBox(height: 10),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

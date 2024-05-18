import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../Review/review_model.dart';
import '../Review/review_service.dart';
import '../Utilities/colors.dart';
import '../Utilities/ResponsiveDim.dart';
import '../Widgets/bigText.dart';
import '../Widgets/profile_image_widget.dart';

class ReviewAndRatings extends StatefulWidget {
  final String ratingTo;
  const ReviewAndRatings({Key? key, required this.ratingTo}) : super(key: key);

  @override
  State<ReviewAndRatings> createState() => _ReviewAndRatingsState();
}

class _ReviewAndRatingsState extends State<ReviewAndRatings> {
  ReviewService service = ReviewService();
  List<Review> reviewsData = [];
  double averageReview = 0.0;

  @override
  void initState() {
    super.initState();
    fetchReviewsData();
  }

  Future<void> fetchReviewsData() async {
    try {
      averageReview = await service.getAverageRatingByRatingTo(widget.ratingTo);
      reviewsData = await service.getReviewsByRatingTo(widget.ratingTo);
    } catch (e) {
      print("Error fetching data: $e");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ratings and reviews",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Ratings and reviews are verified and are from users who have already used respective services",
                  style: TextStyle(fontSize: 16, fontFamily: "poppins"),
                ),
              ),
              SizedBox(height: 8),
              // Display average rating and total reviews count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        averageReview.toStringAsFixed(1),
                        style: TextStyle(fontSize: 52),
                      ),
                      Row(
                        children: [
                          // Display star rating
                          RatingBarIndicator(
                            rating: averageReview,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.blue,
                            ),
                            itemCount: 5,
                            itemSize: 15.0,
                            direction: Axis.horizontal,
                          ),
                          SizedBox(width: 5),
                          Text("(${reviewsData.length})"), // Display total reviews count
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 5; i >= 1; i--)
                          Row(
                            children: [
                              Text("$i"),
                              SizedBox(width: 10),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: (i) * 0.2,
                                  minHeight: 11,
                                  backgroundColor: Colors.grey,
                                  borderRadius: BorderRadius.circular(6),
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              // Display individual review cards
              Column(
                children:    reviewsData.map((review) {
                  return Card(
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0,top: 5),
                          child: Row(
                            children: [
                              ProfileImage(
                                bytes: review.profileImage,
                                width: 35,
                                height: 35,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: BigText(text: review.ratingFrom),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                          child: Row(

                            children: [
                              RatingBarIndicator(
                                rating: review.rating!.toDouble(),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.blue,
                                ),
                                itemCount: 5,
                                itemSize: 15.0,
                                direction: Axis.horizontal,
                              ),
                              SizedBox(width: 10,),
                              Text("${review.reviewDate}"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8,left: 25,top: 5),
                          child: Text(review.comment ?? ""),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

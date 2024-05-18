import 'dart:convert';
import 'dart:typed_data';

import 'package:hatbazarsample/main.dart';
import 'package:intl/intl.dart';

class Review {
  final int? id;
  final int? rating;
  final String? comment;
  final String ratingFrom;
  final String ratingTo;
  final Uint8List? profileImage;
  final String? reviewDate;

  Review({
    this.id,
    this.profileImage,
    this.rating,
    this.comment,
    required this.ratingFrom,
    required this.ratingTo,
    this.reviewDate
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    String reviewDateStr = json['reviewDate'];
    DateTime reviewDate = DateTime.parse(reviewDateStr);
    String reviewDateOnly = DateFormat.yMMMd().format(reviewDate);

    return Review(
      id: json['id'],
      profileImage: json['profileImage'] != null ? base64Decode(json['profileImage']) : null,
      rating: json['rating'],
      comment: json['comment'],
      ratingFrom: json['ratingFrom'],
      ratingTo: json['ratingTo'],
      reviewDate:reviewDateOnly,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'ratingFrom': ratingFrom,
      'ratingTo': ratingTo,
      'profileImage': userDataJson['image'],
    };
  }
}

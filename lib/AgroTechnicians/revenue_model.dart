import 'package:flutter/foundation.dart';

class Revenue {
  final double amount;
  final String token;
  final DateTime createdDate;

  Revenue({
    required this.amount,
    required this.token,
    required this.createdDate,
  });

  factory Revenue.fromJson(Map<String, dynamic> json) {
    return Revenue(
      amount: json['amount'] ?? 0.0,
      token: json['token'] ?? '',
      createdDate: DateTime.parse(json['createdDate'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'token': token,
      'createdDate': '${createdDate.year}-${createdDate.month.toString().padLeft(2, '0')}-${createdDate.day.toString().padLeft(2, '0')}',
    };
  }
}

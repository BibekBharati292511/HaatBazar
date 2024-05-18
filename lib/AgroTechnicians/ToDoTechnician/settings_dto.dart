import 'package:flutter/material.dart';

class TechnicianSettings {
  final int? id;
  final String category;
  final double chargePerHour;
  final String startTime;
  final String endTime;
  final String certificateImage;
  final String userToken;

  TechnicianSettings({
    this.id,
    required this.category,
    required this.chargePerHour,
    required this.startTime,
    required this.endTime,
    required this.certificateImage,
    required this.userToken,
  });

  factory TechnicianSettings.fromJson(Map<String, dynamic> json) {
    return TechnicianSettings(
      id: json['id'],
      category: json['category'],
      chargePerHour: json['chargePerHour'],
      startTime: (json['startTime']),
      endTime: (json['endTime']),
      certificateImage: json['certificateImage'],
      userToken: json['userToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'chargePerHour': chargePerHour,
      'startTime': (startTime),
      'endTime':(endTime),
      'certificateImage': certificateImage,
      'userToken': userToken,
    };
  }

  static TimeOfDay? _parseTime(String? timeStr) {
    if (timeStr == null) {
      return null;
    }
    final parts = timeStr.split(":");
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  static String? _formatTime(TimeOfDay? time) {
    if (time == null) {
      return null;
    }
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
}

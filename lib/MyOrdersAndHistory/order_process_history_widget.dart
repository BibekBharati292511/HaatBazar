import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Model representing an order process history event
class OrderProcessHistory {
  final int id;
  final String orderId;
  final String message;

  OrderProcessHistory({
    required this.id,
    required this.orderId,
    required this.message,
  });

  factory OrderProcessHistory.fromJson(Map<String, dynamic> json) {
    return OrderProcessHistory(
      id: json['id'],
      orderId: json['orderId'],
      message: json['message'],
    );
  }
}

// Widget for displaying a single timeline event
class TimelineEvent extends StatelessWidget {
  final IconData icon;
  final String label;
  final String message;

  const TimelineEvent({super.key,
    required this.icon,
    required this.label,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(height: 10,),
          Row(
            children: [
              Column(
                children: [
                  Icon(icon, size: 40,color: Colors.green,),
                  Container(
                    width: 3,
                    height: 50,
                    color: Colors.redAccent
                  ), // Line connecting the timeline
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Text(message,style: TextStyle(fontWeight: FontWeight.w400,fontFamily: "poppins",fontSize: 15.5),),
                  ],
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

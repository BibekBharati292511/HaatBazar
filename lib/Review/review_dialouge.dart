import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hatbazarsample/MyOrdersAndHistory/order_and_history_main.dart';
import 'package:hatbazarsample/SellerCenter/Technician_booking/SellerBookingHistory.dart';

import '../main.dart';

class ReviewDialog extends StatefulWidget {
  final Function(int, String) onSubmit;

  const ReviewDialog({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _ReviewDialogState createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  int _rating = 0;
  String _comment = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rate and Comment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Rating widget
          RatingBar(
            initialRating: _rating.toDouble(),
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 30.0,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating.toInt();
              });
            },
            ratingWidget: RatingWidget(
              full: Icon(Icons.star, color: Colors.amber),
              half: Icon(Icons.star_half, color: Colors.amber),
              empty: Icon(Icons.star_border, color: Colors.amber),
            ),
          ),
          // Comment text field
          TextField(
            decoration: InputDecoration(labelText: 'Comment'),
            onChanged: (value) {
              setState(() {
                _comment = value;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Submit'),
          onPressed: () async {
            await widget.onSubmit(_rating, _comment);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Review added"), backgroundColor: Colors.green),
            );
            role=="Sellers"?
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SellerHistoryPage())):
            Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderAndHistoryMainPage()));
          },
        ),
      ],
    );
  }
}

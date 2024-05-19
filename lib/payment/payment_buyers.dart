import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hatbazarsample/AgroTechnicians/revenue_model.dart';
import 'package:hatbazarsample/AgroTechnicians/revenue_service.dart';
import 'package:hatbazarsample/Review/review_service.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

import '../AddToCart/add_to_cart_page.dart';
import '../HomePage/bottom_navigation.dart';
import '../MyOrdersAndHistory/order_and_history_main.dart';
import '../OrderTracking/Order.dart';
import '../OrderTracking/order_tracking_dart.dart';
import '../OrderTracking/store_order_tracking.dart';
import '../Review/review_dialouge.dart';
import '../SellerCenter/Technician_booking/booking_model.dart';
import '../SellerCenter/Technician_booking/booking_service.dart';
import '../SellerCenter/order_request/order_services_seller.dart';
import '../Widgets/custom_button.dart';
import '../main.dart';

final RevenueService service = new RevenueService();
DateTime currentDate = DateTime.now();
final ReviewService services =new ReviewService();
// khalti payment initiation
void khaltiPaymentBuyers(
    String email,
    String firstName,
    String lastName,
    BuildContext context,
    String sellerToken,
    String orderIds,
    OrderTracking order,
    List<OrderItem> orderItem,
    String sellerName,

    ) {

  final paymentConfig = PaymentConfig(
    amount: 1000,
    productIdentity: sellerToken,
    productName: '$firstName $lastName',
  );

  // Define payment preferences
  final paymentPreferences = [
    PaymentPreference.khalti,
    PaymentPreference.eBanking,
  ];

  // Initiate the Khalti payment
  KhaltiScope.of(context).pay(
    config: paymentConfig,
    preferences: paymentPreferences,
    onSuccess: (success) async {
      print(email);
      if(order.paymentMethod=="Cash on Delivery (COD)"){
        await orderTracker(
            order.orderId, "Order Completed on date ${DateTime.now()}");
        await updateOrderTracking(order.orderId, "Completed");
        double totalPrice=0;
        for(var orders in orderItem){
          totalPrice+=orders.price*orders.quantity;
          Revenue revenue = Revenue(
            amount: orders.price *orders.quantity,
            token: orders.productName,
            createdDate: DateTime(currentDate.year, currentDate.month, currentDate.day),
          );
          service.addRevenue(revenue);
        }
        Revenue revenue = Revenue(
          amount: totalPrice,
          token: sellerToken,
          createdDate: DateTime(currentDate.year, currentDate.month, currentDate.day),
        );
        service.addRevenue(revenue);

        notificationService.createNotification(
          email,
          "Order Transaction Completed successfully",
          "",
          "",
          false,
        );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Payment Successful"),
                backgroundColor: Colors.green),
          );

        showRatingDialog(context, order.orderItems,sellerName,order);
      }
    },
    onFailure: (failure) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Failed: ${failure.message}"), backgroundColor: Colors.red),
      );
    },
    onCancel: () {
      // Display a cancellation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment Cancelled")),
      );
    },
  );

}
void showRatingDialog(BuildContext context, List<OrderItem> orderItems, String sellerName,OrderTracking order) {
  int sellerRating = 0;
  String sellerComment = '';
  List<int> productRatings = List.filled(orderItems.length, 0);
  List<String> productComments = List.filled(orderItems.length, '');

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text("Rate Seller and Products"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 8),
                    Text("Seller: $sellerName",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text("Rate Seller:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    RatingBar(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 30.0,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      onRatingUpdate: (rating) {
                        // Update seller rating
                        setState(() {
                          sellerRating = rating.toInt();
                        });
                      },
                      ratingWidget: RatingWidget(
                        full: Icon(Icons.star, color: Colors.amber),
                        half: Icon(Icons.star_half, color: Colors.amber),
                        empty: Icon(Icons.star_border, color: Colors.amber),
                      ),
                    ),
                    // Seller comment text field
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'Seller Comment'),
                      onChanged: (value) {
                        // Update seller comment
                        setState(() {
                          sellerComment = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Text("Rate Products:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Column(
                      children: List.generate(orderItems.length, (index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(orderItems[index].productName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            RatingBar(
                              initialRating: 0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemSize: 30.0,
                              itemPadding: EdgeInsets.symmetric(
                                  horizontal: 4.0),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  productRatings[index] = rating.toInt();
                                });
                              },
                              ratingWidget: RatingWidget(
                                full: Icon(Icons.star, color: Colors.amber),
                                half: Icon(
                                    Icons.star_half, color: Colors.amber),
                                empty: Icon(
                                    Icons.star_border, color: Colors.amber),
                              ),
                            ),
                            // Product comment text field
                            TextField(
                              decoration: InputDecoration(
                                  labelText: 'Product Comment'),
                              onChanged: (value) {
                                setState(() {
                                  productComments[index] = value;
                                });
                              },
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);

                    print("Seller ratings");
                    print(sellerRating);
                    print(sellerComment);
                    await services.addReview(context: context,
                        rating: sellerRating,
                        comment: sellerComment,
                        ratingFrom: name,
                        ratingTo: sellerName);

                    for (int i = 0; i < orderItems.length; i++) {
                      String productName = orderItems[i].productName;
                      int rating = productRatings[i];
                      String comment = productComments[i];

                      print("Individual ratings");
                      print(productName);
                      print(rating);
                      print(comment);
                      await services.addReview(context: context,
                          rating: rating,
                          comment: comment,
                          ratingFrom: name,
                          ratingTo: productName);
                    }
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text("Review added"),
                          backgroundColor: Colors.green),
                    );
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const OrderAndHistoryMainPage()));
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          },
        );
      });
}



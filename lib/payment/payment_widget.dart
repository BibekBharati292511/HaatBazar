import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hatbazarsample/AgroTechnicians/revenue_model.dart';
import 'package:hatbazarsample/AgroTechnicians/revenue_service.dart';
import 'package:hatbazarsample/Review/review_service.dart';
import 'package:hatbazarsample/main.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

import '../HomePage/bottom_navigation.dart';
import '../Review/review_dialouge.dart';
import '../SellerCenter/Technician_booking/booking_model.dart';
import '../SellerCenter/Technician_booking/booking_service.dart';

final RevenueService service = new RevenueService();
DateTime currentDate = DateTime.now();
final ReviewService services =new ReviewService();
// khalti payment initiation
khaltiPayment(
    String email,
    String firstName,
    String lastName,
    BuildContext context,
    BookingModel model,
    ) {

  final paymentConfig = PaymentConfig(
    amount: 1000,
    productIdentity: model.technicianToken,
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
      paymentTracker=true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaction Successful"),
            backgroundColor: Colors.green),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ReviewDialog(
            onSubmit: (rating, comment) {
              services.addReview(context: context, ratingFrom: firstName+lastName, ratingTo: model.technicianToken,rating: rating,comment: comment);
            },
          );
        },
      );
      Revenue revenue = Revenue(
        amount: model.totalPrice!,
        token: model.technicianToken,
        createdDate: DateTime(currentDate.year, currentDate.month, currentDate.day),
      );
      await service.addRevenue(revenue);
      await notificationService.createNotification(
        email,
        "Appointment transaction Completed successfully",
        "",
        "appointmentCompleted",
        false,
      );
      model.status = "Completed";

      await updateBooking(model.id!, model);

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

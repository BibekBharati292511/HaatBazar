import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hatbazarsample/SellerCenter/HomePage/seller_landing_page.dart';
import 'package:hatbazarsample/SellerCenter/Tools/seller_tools.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/SellerCenter/Technician_booking/booking_model.dart';
import 'package:hatbazarsample/SellerCenter/Technician_booking/booking_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'dart:convert';

import '../../AgroTechnicians/revenue_model.dart';
import '../../HomePage/bottom_navigation.dart';
import '../../Model/UserAddress.dart';
import '../../Model/UserData.dart';
import '../../Review/review_dialouge.dart';
import '../../Review/review_service.dart';
import '../../Utilities/ResponsiveDim.dart';
import '../../Widgets/custom_button.dart';
import '../../main.dart';
import '../../payment/payment_widget.dart';


// Future function to fetch seller data
Future<Map<String, dynamic>> fetchTechnicianData(String userToken) async {
  DateTime currentDate = DateTime.now();
  final ReviewService services =new ReviewService();
  final userData = await UserDataService.fetchUserData(userToken);
  final technicianDataJson = jsonDecode(userData);
  final userAddress = await UserAddressService.fetchUserAddress(technicianDataJson["id"]);
  final technicianAddressJson = jsonDecode(userAddress);
  final technicianAddress = technicianAddressJson["address"];

  final technicianBytes = base64Decode(technicianDataJson["image"] ?? '');

  return {
    'data': technicianDataJson,
    'address': technicianAddress,
    'image': technicianBytes,
  };
}

// Future function to show booking detail dialog
Future<void> showBookingDetailDialog(BuildContext context, BookingModel model,) {
  return showDialog(
    context: context,
    builder: (context) {
      return FutureBuilder<Map<String, dynamic>>(
        future: fetchTechnicianData(model.technicianToken),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AlertDialog(
              content: const Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text("Error fetching seller data"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
              ],
            );
          }

          final technicianInfo = snapshot.data!;
          final technicianDataJson = technicianInfo['data'];
          final address = technicianInfo['address'];

          return AlertDialog(
            title: Text(
              "Appointment Details",
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Booker Information
                  Card(
                    elevation: 5,
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.blue),
                      title: Text(
                        "${technicianDataJson['firstName']} ${technicianDataJson['lastName']}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email: ${technicianDataJson['email']}", style: GoogleFonts.poppins()),
                          Text("Contact: ${technicianDataJson['phone_number']}", style: GoogleFonts.poppins()),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Address Information
                  Card(
                    color: Colors.white,
                    elevation: 5,
                    child: ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.green),
                      title: Text(
                        "Worked Venue",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${address["cityDistrict"]}, ${address["state"]}, ${address["country"]}',
                            style: GoogleFonts.poppins(color: Colors.black54),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, 'viewAddress'),
                            child: Row(
                              children: [
                                const Icon(Icons.map, color: Colors.blue),
                                const SizedBox(width: 5),
                                Text(
                                  "View on Map",
                                  style: GoogleFonts.poppins(color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Work Details
                  Card(
                    elevation: 5,
                    child: ListTile(
                      leading: const Icon(Icons.work, color: Colors.orange),
                      title: Text(
                        "Task Detail",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Started at: ${model.startTime}", style: GoogleFonts.poppins()),
                          Text("Total time: ${model.duration} hour", style: GoogleFonts.poppins()),
                          Text("Total Charge: ${model.totalPrice}", style: GoogleFonts.poppins()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              CustomButton(
                buttonText: "Pay Now",
                onPressed: () =>
                {
                  Navigator.pop(context),
                  showDialog(context: context,
                      builder: (BuildContext context){
                    return AlertDialog(
                      title: Text('Payment Options'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(FontAwesomeIcons.moneyBill,color: Colors.green,),
                            title: Text('Paid through cash'),
                            onTap: () async {
                              Navigator.pop(context);
                              Revenue revenue = Revenue(
                                amount: model.totalPrice!,
                                token: model.technicianToken,
                                createdDate: DateTime(currentDate.year, currentDate.month, currentDate.day),
                              );
                              await service.addRevenue(revenue);
                             await notificationService.createNotification(
                                technicianDataJson['email'],
                                "Appointment transaction Completed successfully",
                                "",
                                "appointmentCompleted",
                                false,
                              );
                              model.status = "Completed";

                              await updateBooking(model.id!, model);

                              if(context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Payment Successful"),
                                      backgroundColor: Colors.green),
                                );
                              }

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ReviewDialog(
                                    onSubmit: (rating, comment) {
                                      services.addReview(context: context, ratingFrom: technicianDataJson['firstName']+technicianDataJson['lastName'], ratingTo: model.technicianToken,rating: rating,comment: comment);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(FontAwesomeIcons.creditCard,color: Colors.blue,),
                            title: Text('Card Payment'),
                            onTap: () {
                              // Action on selecting card payment

                            },
                          ),
                          ListTile(
                            leading: Image.asset('assets/images/icons/img.png',width: 35,height: 35,),
                            title: Text('Esewa Payment'),
                            onTap: () {
                              // Action on selecting Esewa payment
                             // paywithKhalti(technicianDataJson['firstName'], technicianDataJson['firstName'], context, model);
                              khaltiPayment(technicianDataJson['email'], technicianDataJson['firstName'],technicianDataJson['lastName'],context,model);
                             // Navigator.push(context, MaterialPageRoute(builder: (context)=>SellerHistoryPage()));
                            },
                          ),

                          ListTile(
                            leading: Image.asset('assets/images/icons/khalti.png',width: 70,height: 60,),
                            title: Text('Khalti Payment'),
                            onTap: ()  {
                             // Navigator.pop(context);
                               khaltiPayment(technicianDataJson['email'], technicianDataJson['firstName'],technicianDataJson['lastName'],context,model);
                              },
                          ),
                        ],
                      ),
                    );
                      })
                },
                width: ResponsiveDim.screenWidth,
                height: 45,
                color: Colors.green,
              ),
              CustomButton(
                buttonText: "OK",
                onPressed: () => Navigator.pop(context),
                width: ResponsiveDim.screenWidth,
                height: 45,
                color: Colors.red,
              ),
            ],
          );
        },
      );
    },
  );
}


class SellerHistoryPage extends StatefulWidget {
  const SellerHistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<SellerHistoryPage> {
  late Future<List<History>> _futureHistory;

  @override
  void initState() {
    super.initState();
    _futureHistory = _fetchHistory();
  }

  // Fetch history tasks with specific statuses
  Future<List<History>> _fetchHistory() async {
    final SellerToken = token;
    const statusCompletionRequested = "Completion Requested";
    const statusCompleted = "Completed";

    final completionRequestedTasks = await getBookingsByStatusAndSellerToken(
        statusCompletionRequested, SellerToken);
    final completedTasks = await getBookingsByStatusAndSellerToken(statusCompleted, SellerToken);

    final allHistory = [...completionRequestedTasks, ...completedTasks];

    return allHistory
        .map((booking) => History(
        booking.appointmentTitle,
        booking.service,
        booking.status,
        booking))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        leading: 
          GestureDetector(
            onTap: (){
             // Navigator.push(context,MaterialPageRoute(builder:  (context)=>SellerLandingPage()));
            Navigator.of(context).pop();
            },
              child: Icon(Icons.arrow_back,color: Colors.white,))

      ),
      body: FutureBuilder<List<History>>(
        future: _futureHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final historyTasks = snapshot.data ?? [];

            return ListView.builder(
              itemCount: historyTasks.length,
              itemBuilder: (context, index) {
                final history = historyTasks[index];
                return _buildHistoryCard(context, history, index);
              },
            );
          }
        },
      ),
    );
  }

  // Build history card with a gesture to open booking details
  Widget _buildHistoryCard(BuildContext context, History history, int index) {
    Color cardColor = index % 2 == 0 ? Colors.white : Colors.grey[200]!;

    return GestureDetector(
      onTap: () {
        showBookingDetailDialog(context, history.model);
      },
      child: Card(
        elevation: 4,
        color: cardColor,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          leading: const Icon(Icons.history, color: Colors.blue),
          title: Text(history.title),
          subtitle: Text("Service: ${history.service}"),
          trailing: Text(
            history.status,
            style: TextStyle(
              color: history.status == "Completed" ? Colors.green : Colors.blue,
            ),
          ),
        ),
      ),
    );
  }



}





class History {
  final String title;
  final String service;
  final String status;
  final BookingModel model;

  History(this.title, this.service, this.status, this.model);
}

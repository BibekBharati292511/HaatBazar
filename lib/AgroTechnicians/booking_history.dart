import 'package:flutter/material.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/SellerCenter/Technician_booking/booking_model.dart';
import 'package:hatbazarsample/SellerCenter/Technician_booking/booking_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import '../HomePage/bottom_navigation.dart';
import '../Model/UserAddress.dart';
import '../Model/UserData.dart';
import '../Utilities/ResponsiveDim.dart';
import '../Widgets/custom_button.dart';
import '../main.dart';

// Future function to fetch seller data
Future<Map<String, dynamic>> fetchSellerData(String userToken) async {
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
Future<void> showBookingDetailDialog(BuildContext context, BookingModel model) {
  return showDialog(
    context: context,
    builder: (context) {
      return FutureBuilder<Map<String, dynamic>>(
        future: fetchSellerData(model.sellerToken),
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

          final sellerInfo = snapshot.data!;
          final sellerDataJson = sellerInfo['data'];
          final address = sellerInfo['address'];

          return AlertDialog(
            title: Text(
              "Booker Details",
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
                        "${sellerDataJson['firstName']} ${sellerDataJson['lastName']}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email: ${sellerDataJson['email']}", style: GoogleFonts.poppins()),
                          Text("Contact: ${sellerDataJson['phone_number']}", style: GoogleFonts.poppins()),
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
                        "Location",
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
                        "Work Details",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Estimated Earning: ${model.totalPrice}", style: GoogleFonts.poppins()),
                          Text("Booked Duration: ${model.duration} hour", style: GoogleFonts.poppins()),
                          Text("Appointment Time: ${model.startTime}", style: GoogleFonts.poppins()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
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

// HistoryPage widget to show tasks with "Completion Requested" and "Completed"
class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<History>> _futureHistory;

  @override
  void initState() {
    super.initState();
    _futureHistory = _fetchHistory();
  }

  // Fetch history tasks with specific statuses
  Future<List<History>> _fetchHistory() async {
    final technicianToken = token;
    const statusCompletionRequested = "Completion Requested";
    const statusCompleted = "Completed";

    final completionRequestedTasks = await getBookingsByTechnicianToken(
        statusCompletionRequested, technicianToken);
    final completedTasks = await getBookingsByTechnicianToken(statusCompleted, technicianToken);

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

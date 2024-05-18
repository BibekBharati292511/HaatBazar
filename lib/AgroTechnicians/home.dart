import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hatbazarsample/AgroTechnicians/booking_requests.dart';
import 'package:hatbazarsample/AgroTechnicians/sheduled_task.dart';
import 'package:hatbazarsample/AgroTechnicians/technician_landing_page.dart';
import 'package:hatbazarsample/SellerCenter/Technician_booking/booking_model.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/main.dart';
import 'package:intl/intl.dart';

import '../HomePage/bottom_navigation.dart';
import '../Model/UserAddress.dart';
import '../Model/UserData.dart';
import '../SellerCenter/Technician_booking/booking_service.dart';
import '../Utilities/ResponsiveDim.dart';
import '../Widgets/bigText.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/smallText.dart';
import 'models.dart';
import 'package:google_fonts/google_fonts.dart';

class TechnicianHomePage extends StatelessWidget {
  final int completedTasks;
  final int pendingTasks;
  final int inProgressTasks;
  final int upComingTasks;
  final List<Schedule> ongoingSchedules;
  final List<BookingRequest> bookingRequests;
  final BuildContext context;

  const TechnicianHomePage({
    super.key,
    required this.context,
    required this.upComingTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.inProgressTasks,
    required this.ongoingSchedules,
    required this.bookingRequests,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              "Task Overview",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildTaskOverview(), // New section for task summary
            const Divider(height: 20, thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Ongoing Schedules",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                CustomButton(buttonText: "view all", onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AllScheduledTasksPage(schedules: ongoingSchedules)));
                },width: 120,height: 30,color: Colors.red,),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: ongoingSchedules.length,
                itemBuilder: (context, index) {
                  final schedule = ongoingSchedules[index];
                  return _buildScheduleCard(schedule, index);
                },
              ),
            ),
            const Divider(height: 20, thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Booking Requests",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                CustomButton(buttonText: "view all", onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AllBookingRequestsPage(bookingRequests: bookingRequests)));
                },width: 120,height: 30,color: Colors.red,),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: bookingRequests.length,
                itemBuilder: (context, index) {
                  final request = bookingRequests[index];
                  return _buildBookingRequestCard(request, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // New widget for task overview
  Widget _buildTaskOverview() {

    return Card(
      elevation: 4,
      color: Colors.blueGrey[50], // Light color for overview
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTaskSummary("Completed", completedTasks, Colors.green),
            _buildTaskSummary("Pending", pendingTasks, Colors.orange),
            _buildTaskSummary("In Progress", inProgressTasks, Colors.blue),
            _buildTaskSummary("Up Coming", upComingTasks, Colors.red),
          ],
        ),
      ),
    );
  }


  Widget _buildTaskSummary(String label, int count, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.task_alt, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildScheduleCard(Schedule schedule, int index) {
    Color cardColor = index % 2 == 0 ? Colors.white : Colors.grey[200]!;

    return GestureDetector(
      onTap: (){
        print("press");
        showBookingDetailDialog(schedule.onClick,context, schedule.model);
      },
      child: Card(
        elevation: 4,
        color: cardColor,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: const Icon(Icons.event, color: Colors.green),
          title: Text(schedule.title),
          subtitle: Text("Service: ${schedule.location}"),
          trailing: Text(
            schedule.status,
            style: TextStyle(
              color: schedule.status == "In Progress" ? Colors.blue : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingRequestCard(BookingRequest request, int index) {
    Color cardColor = index % 2 == 0 ? Colors.white : Colors.grey[200]!;

    return GestureDetector(
      onTap: (){
        showBookingDetailDialog(request.onAccept,context,request.model);
      },
      child: Card(
        elevation: 4,
        color: cardColor,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: const Icon(Icons.book_online, color: Colors.orange),
          title: Text(request.title),
          subtitle: Text("Service: ${request.service}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: () => request.onAccept(),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => request.onDecline(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> showBookingDetailDialog(Function onClick,BuildContext context, BookingModel model) {
    return showDialog(
    //  barrierColor: AppColors.primaryColor,
      context: context,
      builder: (context) {
        return FutureBuilder<Map<String, dynamic>>(
          future: fetchSellerData(model.sellerToken),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return AlertDialog(
                content: Center(child: CircularProgressIndicator()),
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
                    Card(
                      elevation: 5,
                      child: ListTile(
                        leading: Icon(Icons.person, color: Colors.blue),
                        title: Text(
                          "${sellerDataJson["firstName"]} ${sellerDataJson["lastName"]}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email: ${sellerDataJson["email"]}",
                              style: GoogleFonts.poppins(),
                            ),
                            Text(
                              "Contact: ${sellerDataJson["phone_number"]}",
                              style: GoogleFonts.poppins(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      color: Colors.white,
                      elevation: 9,
                      child: ListTile(
                        leading: Icon(Icons.location_on, color: Colors.green),
                        title: Text(
                          "Location",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${address["cityDistrict"]}, ${address["state"]}, ${address["country"]}',
                              style: GoogleFonts.poppins(color: Colors.black54),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'viewAddress');
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.map, color: Colors.blue),
                                  SizedBox(width: 5),
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
                    SizedBox(height: 10),
                    Card(
                      elevation: 5,
                      child: ListTile(
                        leading: Icon(Icons.work, color: Colors.orange),
                        title: Text(
                          "Work Details",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Estimated Earning: ${model.totalPrice}",
                              style: GoogleFonts.poppins(),
                            ),
                            Text(
                              "Booked Duration: ${model.duration} hour",
                              style: GoogleFonts.poppins(),
                            ),
                            Text(
                              "Appointment Time: ${model.startTime}",
                              style: GoogleFonts.poppins(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                if (model.status == "Pending")
                  CustomButton(
                    buttonText: "Ok",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    width: ResponsiveDim.screenWidth,
                    height: 45,
                    color: Colors.blue,
                  ),

                if (model.status != "Pending") ...[
                  CustomButton(
                    buttonText: "Complete task",
                    onPressed: ()  {
                      if (model.status == "In Progress") {
                        Navigator.pop(context);
                         _updateAppointment(onClick,context, sellerDataJson["email"], model);
                      } else {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Request cannot be sent for upcoming schedule"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    width: ResponsiveDim.screenWidth,
                    height: 45,
                  ),

                  CustomButton(
                    buttonText: "Cancel",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    width: ResponsiveDim.screenWidth,
                    height: 45,
                    color: Colors.red,
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  DateTime _parseTime(String time) {
    try {
      final format = DateFormat("HH:mm:ss");
      return format.parse(time);
    } catch (e) {
      print("Error parsing time: $e");
      try {
        final formatWithoutSeconds = DateFormat("HH:mm");
        return formatWithoutSeconds.parse(time);
      } catch (e) {
        print("Error parsing time without seconds: $e");
        throw FormatException("Invalid time format");
      }
    }
  }

  List<String> generateTimeSlots(String startTime, String endTime, int intervalInMinutes) {
    final List<String> timeSlots = [];
    final startDateTime = _parseTime(startTime);
    final endDateTime = _parseTime(endTime);

    var currentSlot = startDateTime;
    while (currentSlot.isBefore(endDateTime) ||
        currentSlot.isAtSameMomentAs(endDateTime)) {
      timeSlots.add(DateFormat("HH:mm").format(currentSlot));
      currentSlot = currentSlot.add(Duration(minutes: intervalInMinutes));
    }
    return timeSlots;
  }
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
  void _updateAppointment(
      Function onClick,
      BuildContext context,
      String email,
      BookingModel model,
      )  {
    final durationController = TextEditingController(text: model.duration?.toString() ?? '');
    final priceController = TextEditingController(text: model.totalPrice?.toString()??'');
    final startTimeController = TextEditingController(
      text: model.startTime ?? '',
    );
    double? duration = model.duration;
    double totalPrice = model.totalPrice ?? 0;

    Future<void> _selectTime(BuildContext context) async {
      TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        // Format the time as HH:mm
        final formattedTime = picked.format(context); // May need adjustment
        final DateTime now = DateTime.now();
        final dateTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        final timeFormat = DateFormat('HH:mm'); // Ensures leading zeros
        final timeString = timeFormat.format(dateTime);

        startTimeController.text = timeString;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Booking"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: durationController,
                      decoration: InputDecoration(labelText: "Duration (hours)"),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: startTimeController,
                      readOnly: true,
                      decoration: InputDecoration(labelText: "Start Time (HH:mm)"),
                      onTap: () => _selectTime(context), // Opens time picker on tap
                    ),
                    TextField(
                      controller: priceController,
                      decoration: InputDecoration(labelText: "Total Charge"),

                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            CustomButton(
              buttonText: "Cancel",
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.red,
              width: ResponsiveDim.screenWidth,
              height: 40,
            ),
            CustomButton(
              buttonText: "Send Request",
              width:ResponsiveDim.screenWidth,
              onPressed: () async {
                final startTime = startTimeController.text.trim();

                if (duration == null || startTime.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Duration or start time is invalid."),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                model.startTime = startTime;
                model.duration = duration;
                model.totalPrice = double.parse(priceController.text);
                model.status="Completion Requested";

                updateBooking(model.id!, model);
                  await notificationService.createNotification(
                      email,
                      "Appointment completion Request from $userEmail",
                      model.id.toString(),
                      "AppointmentCompletion",
                      false
                  );

                 // Navigator.pop(context);
                  onClick();
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>const TechnicianLandingPage()));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Confirmation Request sent successfully"),backgroundColor: Colors.green,),
                  );

                Navigator.pop(context);

              },
              height: 45,
            ),
          ],
        );
      },
    );
  }



}



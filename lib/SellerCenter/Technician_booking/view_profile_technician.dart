import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/SellerCenter/Technician_booking/booking_service.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';
import 'package:hatbazarsample/Widgets/smallText.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/main.dart';
import 'package:http/http.dart' as http;
import 'package:hatbazarsample/SellerCenter/Technician_booking/profile_Image_view.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';// For opening email and phone
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:intl/intl.dart';

import '../../AgroTechnicians/ToDoTechnician/settings_dto.dart';
import 'booking_model.dart';

class ViewProfileTechnician extends StatefulWidget {
  final Map<String, dynamic> technicianDataJson;
  final Map<String, dynamic> technicianAddress;
  final Uint8List? technicianBytes;
  final String technicianToken;

  ViewProfileTechnician({
    required this.technicianToken,
    required this.technicianDataJson,
    required this.technicianBytes,
    required this.technicianAddress,
    Key? key,
  }) : super(key: key);

  @override
  _ViewProfileTechnicianState createState() => _ViewProfileTechnicianState();
}

class _ViewProfileTechnicianState extends State<ViewProfileTechnician> {
  TechnicianSettings? technicianSettings;

  @override
  void initState() {
    super.initState();
    fetchTechnicianDetails();
  }

  void fetchTechnicianDetails() async {
    final response = await http.get(Uri.parse(
        '${serverBaseUrl}appointment/technician-settings/userToken?userToken=${widget
            .technicianToken}'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        technicianSettings = TechnicianSettings.fromJson(json);
      });
    } else {
      showErrorDialog(context, 'Failed to fetch technician details');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (technicianSettings == null) {
      return Scaffold(
        appBar: AppBar(
          title: BigText(text: "Technician Profile", color: Colors.white),
          backgroundColor: AppColors.primaryColor,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final technician = widget.technicianDataJson;
    final address = widget.technicianAddress;

    return Scaffold(
      appBar: AppBar(
        title: BigText(text: "Technician Profile", color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Profile Image
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: ViewProfileImage(
                            bytes: widget.technicianBytes,
                            width: 150,
                            height: 210,
                          ),
                        ),
                        SizedBox(width: 25),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BigText(
                                  overflow: TextOverflow.ellipsis,
                                  text:
                                  '${technician["firstName"]} ${technician["lastName"]}',
                                  weight: FontWeight.bold,
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.category, color: Colors.green),
                                    SizedBox(width: 8),
                                    SmallText(
                                      text: technicianSettings!.category,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 80),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _sendEmail(technician["email"]);
                                  },
                                  child: Icon(
                                    Icons.email,
                                    color: Colors.blue,
                                    size: 40,
                                  ),
                                ),
                                SizedBox(width: 35),
                                GestureDetector(
                                  onTap: () {
                                    _makePhoneCall(technician["phone_number"]);
                                  },
                                  child: Icon(
                                    Icons.phone,
                                    color: AppColors.primaryColor,
                                    size: 40,
                                  ),
                                ),
                                SizedBox(width: 35),
                                GestureDetector(
                                  onTap: () {
                                    _bookAppointment(
                                        context, technicianSettings!.userToken,technician["email"]??"",technicianSettings!);
                                  },
                                  child: Icon(
                                    Icons.book,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    // Location Information
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BigText(text: "Location"),
                        SizedBox(height: ResponsiveDim.height10),
                        Row(
                          children: [
                            Expanded(
                              child: SmallText(
                                color: Colors.grey,
                                overFlow: TextOverflow.ellipsis,
                                text:
                                '${address['cityDistrict']}, ${address['state']}, ${address['country']}',
                              ),
                            ),
                            SizedBox(width: ResponsiveDim.width10),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'viewAddress');
                              },
                              child: Icon(
                                Icons.my_location,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveDim.height15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BigText(text: "Work Information"),
                        SizedBox(height: ResponsiveDim.height10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              shadowColor: Colors.grey.withOpacity(0.5),
                              child: Container(
                                width: ResponsiveDim.screenWidth / 2.3,
                                height: 300,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              const Text(
                                                "Work Time",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'poppins',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                '${technicianSettings!
                                                    .startTime} - ${technicianSettings!
                                                    .endTime}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "poppins",
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 0.1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.asset(
                                          'assets/images/workTime.png',
                                          width: 180,
                                          height: 205,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              shadowColor: Colors.grey.withOpacity(0.5),
                              child: Container(
                                width: ResponsiveDim.screenWidth / 2.3,
                                height: 300,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              const Text(
                                                "Charge",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'poppins',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Rs ${technicianSettings!
                                                    .chargePerHour}/hour',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "poppins",
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 0.1),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyuiAgGsW9PopKJz7RZJJHl5tKzOaIGi6nXa2do8lMNw&s',
                                          width: 180,
                                          height: 205,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveDim.height15),
                    CustomButton(
                      buttonText: "Book Now",
                      onPressed: () {
                        _bookAppointment(context,technicianSettings!.userToken,technician["email"]??"", technicianSettings!);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendEmail(String email) {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
    );
    _launchUrl(uri);
  }

  void _makePhoneCall(String phoneNumber) {
    final uri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    _launchUrl(uri);
  }

  void _launchUrl(Uri uri) async {
    showErrorDialog(context, 'Could not launch $uri');
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

  List<String> generateTimeSlots(String startTime, String endTime,
      int intervalInMinutes) {
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


  void _bookAppointment(BuildContext context,
      String technicianToken,
      String email,
      TechnicianSettings technicianSettings) {
    final titleController = TextEditingController();
    final serviceController = TextEditingController();
    final durationController = TextEditingController();
    late final duration;


    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final availableTimeSlots = generateTimeSlots(
            technicianSettings.startTime,
            technicianSettings.endTime,
            60,
          );

          String? selectedStartTime;
          double totalPrice = 0.0;
          String? price;

          return AlertDialog(
            title: Text("Book an Appointment"),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: "Appointment Title",
                        ),
                      ),
                      TextField(
                        controller: serviceController,
                        decoration: InputDecoration(
                          labelText: "Service Required",
                        ),
                      ),
                      TextField(
                        controller: durationController,
                        decoration: InputDecoration(
                          labelText: "Duration (hours)",
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          duration = double.tryParse(value);
                          if (duration != null) {
                            setState(() {
                              totalPrice =
                                  duration * technicianSettings.chargePerHour;
                            });
                            price=totalPrice.toString();

                          }
                        },
                      ),
                      DropdownButton<String>(
                        hint: Text("Select Start Time"),
                        value: selectedStartTime,
                        items: availableTimeSlots.map((time) {
                          return DropdownMenuItem<String>(
                            value: time,
                            child: Text(time),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedStartTime = newValue;
                          });
                        },
                      ),
                      if (totalPrice > 0)
                        Text("Estimated Price: Rs ${totalPrice.toStringAsFixed(
                            2)}"),
                    ],
                  ),
                );
              },
            ),
            actions: [
              Row(
                children: [
                  Row(
                    children: [
                      CustomButton(
                        buttonText: "Cancel",
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Colors.red,
                        width: 120,
                        height: 40,
                      ),
                      CustomButton(
                        buttonText: "Book",
                        onPressed: () {
                          totalPrice = duration * technicianSettings.chargePerHour;
                          BookingModel model;
                          final booking = BookingModel(
                            appointmentTitle: titleController.text,
                            service: serviceController.text,
                            startTime: selectedStartTime,
                            duration: double.tryParse(durationController.text),
                            totalPrice: totalPrice,
                            sellerToken: userToken!,
                            technicianToken: technicianToken,
                            status: "Pending",
                          );
                          print("bookign here");
                          print(booking.technicianToken);
                          print(booking.service);
                          print(booking.startTime);
                          print(booking.duration);
                          print(booking.totalPrice);
                          print(booking.sellerToken);
                          print(booking.status);
                          print(price);

                          createBooking(context,booking,email);
                          Navigator.of(context).pop();
                        },
                        width: 120,
                        height: 40,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(
                "There was an error setting up the appointment. Please try again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ],
          );
        },
      );
    }
  }


  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hatbazarsample/AgroTechnicians/booking_history.dart';
import 'package:hatbazarsample/AgroTechnicians/drawer.dart';
import 'package:hatbazarsample/AgroTechnicians/profile.dart';
import 'package:hatbazarsample/AgroTechnicians/revenue_chart.dart';
import 'package:hatbazarsample/AgroTechnicians/to_do_list_technician.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/HomePage/bottom_navigation.dart';
import 'package:hatbazarsample/Notification/notification_page.dart';
import 'package:hatbazarsample/SellerCenter/Technician_booking/booking_model.dart';
import 'package:hatbazarsample/SellerCenter/Technician_booking/booking_service.dart';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';
import 'package:hatbazarsample/Widgets/profile_image_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'ToDoTechnician/setting_services.dart';
import 'ToDoTechnician/settings_dto.dart';
import 'home.dart';
import 'models.dart';

class TechnicianLandingPage extends StatefulWidget {
  const TechnicianLandingPage({super.key});

  @override
  State<TechnicianLandingPage> createState() => _TechnicianLandingPageState();
}

class _TechnicianLandingPageState extends State<TechnicianLandingPage> {
  bool _isLoading=true;
  int pending = 0;
  int completed = 0;
  int inProgress = 0;
  int upcoming = 0;
  TechnicianSettings? _technicianSettings;

  final TechnicianSettingServices _service = TechnicianSettingServices();
  int _selectedIndex = 0;

  Future<List<BookingModel>>? _futureBookingRequests;
  Future<List<BookingModel>>? _futureSchedule;
  Future<List<BookingModel>>? _futureHistory;

  @override
  void initState() {
    super.initState();
    if (isTechnicianSetupCompleted==true) {
      loadSettings();
      _fetchBookingRequests();
      _fetchSchedules();
    }
  }

  void loadSettings() async {
    final technicianSettings = await _service.findByUserToken(token, context);
    setState(() {
      _technicianSettings = technicianSettings;
    });
  }

  Future<void> _fetchBookingRequests() async {
    final technicianToken = token;
    const status = "Pending";
    setState(() {
      _futureBookingRequests = getBookingsByTechnicianToken(status, technicianToken);
    });
  }

  Future<void> _fetchSchedules() async {
    final technicianToken = token;
    const statusInProgress = "In Progress";
    const statusUpcoming = "Upcoming";

    final inProgressTasks = await getBookingsByTechnicianToken(statusInProgress, technicianToken);
    final upcomingTasks = await getBookingsByTechnicianToken(statusUpcoming, technicianToken);

    setState(() {
      _futureSchedule = Future.wait([Future.value(inProgressTasks), Future.value(upcomingTasks)])
          .then((results) => results.expand((list) => list).toList());
      _getCount();
      _isLoading = false;
    });
  }

  Future<void> _getCount() async {
    final statusCount = await getStatusCount(token);
    setState(() {
      pending = statusCount["Pending"] ?? 0;
      upcoming = statusCount["Upcoming"] ?? 0;
      inProgress = statusCount["In Progress"] ?? 0;
      completed = statusCount["Completed"] ?? 0;
    });
  }

  List<Widget> get _widgetOptions {
    print("jello bnifdsahiasdf");
    print(isTechnicianSetupCompleted);
    return [
      if (isTechnicianSetupCompleted==false)
        const ToDoListTechnician()
      else if (_isLoading)
        const Center(
          child: CircularProgressIndicator(),
        )
      else
        FutureBuilder<List<List<BookingModel>>>(
          future: Future.wait([_futureBookingRequests!, _futureSchedule!]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              print("ruinning snaopshot errors");
              return Text("Error: ${snapshot.error}");
            } else {
              final bookingRequests = snapshot.data?[0] ?? [];
              final ongoingSchedules = snapshot.data?[1] ?? [];
              return TechnicianHomePage(
                ongoingSchedules: _getOngoingSchedules(ongoingSchedules),
                bookingRequests: _getBookingRequestWidgets(bookingRequests),
                completedTasks: completed,
                pendingTasks: pending,
                inProgressTasks: inProgress,
                upComingTasks: upcoming,
                context: context,
              );
            }
          },
        ),
      Text("History", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      Text("Revenue", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      Text("Notification", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    ];
  }

  List<Schedule> _getOngoingSchedules(List<BookingModel> bookingRequests) {
    if (inProgress == 0 && bookingRequests.isNotEmpty) {
      final firstBooking = bookingRequests.first;
      firstBooking.status = "In Progress";
      updateBooking(firstBooking.id!, firstBooking);
      _getCount();
    }

    return bookingRequests.map((booking) {
      return Schedule(
            () async {
          await _fetchBookingRequests();
          await _fetchSchedules();
        },
        booking.appointmentTitle,
        booking.service,
        booking.status,
        booking,
      );
    }).toList();
  }
  List<BookingRequest> _getBookingRequestWidgets(List<BookingModel> bookingRequests) {
    return bookingRequests.map((booking) {
      return BookingRequest(
        booking.appointmentTitle,
        booking,
        booking.service,
            () => _acceptBooking(booking),
            () => _deleteBooking(booking),
      );
    }).toList();
  }

  void _acceptBooking(BookingModel booking) async {
    final updatedStatus = inProgress == 0 ? "In Progress" : "Upcoming";

    final updatedBooking = BookingModel(
      id: booking.id,
      appointmentTitle: booking.appointmentTitle,
      service: booking.service,
      startTime: booking.startTime,
      duration: booking.duration,
      totalPrice: booking.totalPrice,
      sellerToken: booking.sellerToken,
      technicianToken: booking.technicianToken,
      status: updatedStatus,
    );

    try {
      await updateBooking(booking.id!, updatedBooking);
      await _fetchBookingRequests();
      await _fetchSchedules();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Booking accepted, status: $updatedStatus"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to accept booking"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteBooking(BookingModel booking) async {
    try {
      await deleteBooking(booking.id!);
      await _fetchBookingRequests();
      await _fetchSchedules();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Booking deleted"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete booking"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onItemTapped(int index) {
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationPage(
            userId: userEmail!,
            notificationService: notificationService,
          ),
        ),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HistoryPage(),
        ),
      );
    }else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  RevenuePage(token: token,),
        ),
      );
    }
    else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  Drawer(
        backgroundColor: Colors.white,
        child: TechnicianDrawer(),
      ),
      appBar: AppBar(
        title: BigText(
          text: 'Agro Technician Center',
          color: Colors.white,
          size: 22,
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                isTechnicianSetupCompleted
                    ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileTechnician(),
                  ),
                )
                    : showErrorDialog(context, "Set up Settings first");
              },
              child: isTechnicianSetupCompleted
                  ? ProfileImage(
                bytes: bytes,
                width: 35,
                height: 35,
              )
                  : const Icon(
                Icons.account_circle_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
            backgroundColor: AppColors.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: 'History',
            backgroundColor: AppColors.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.monetization_on),
            label: 'Revenue',
            backgroundColor: AppColors.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: _buildNotificationIcon(),
            label: 'Notification',
            backgroundColor: AppColors.primaryColor,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[500],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
      children: [
        const Icon(Icons.notifications),
        if (notificationCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$notificationCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

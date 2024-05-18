import 'package:flutter/material.dart';
import '../Utilities/colors.dart';
import 'models.dart';

class AllBookingRequestsPage extends StatelessWidget {
  final List<BookingRequest> bookingRequests;

  const AllBookingRequestsPage({Key? key, required this.bookingRequests}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Booking Requests",style: TextStyle(color: Colors.white),),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: bookingRequests.length,
          itemBuilder: (context, index) {
            final request = bookingRequests[index];
            return _buildBookingRequestCard(request, index);
          },
        ),
      ),
    );
  }

  Widget _buildBookingRequestCard(BookingRequest request, int index) {
    Color cardColor = index % 2 == 0 ? Colors.white : Colors.grey[200]!;

    return Card(
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
    );
  }
}

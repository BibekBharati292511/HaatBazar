import '../SellerCenter/Technician_booking/booking_model.dart';

class Schedule {
  final String title;
  final String location;
   String status;
  final BookingModel model;
  final Function onClick;

  Schedule(this.onClick,this.title, this.location, this.status,this.model);
}
class History {
  final String title;
  final String service;
  final String status;
  final BookingModel model;

  History(this.title, this.service, this.status,this.model);
}

class BookingRequest {
  final String title;
  final String service;
  final Function onAccept;
  final Function onDecline;
  final BookingModel model;

  BookingRequest(this.title, this.model, this.service, this.onAccept, this.onDecline);
}

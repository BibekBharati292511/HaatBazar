class BookingModel {
  final int? id;
  final String appointmentTitle;
  final String service;
    String? startTime;
   double? duration;
   double? totalPrice;
  final String sellerToken;
  final String technicianToken;
  String status;

  BookingModel({
    this.id,
    required this.appointmentTitle,
    required this.service,
    this.startTime,
    this.duration,
    this.totalPrice,
    required this.sellerToken,
    required this.technicianToken,
    required this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      appointmentTitle: json['appointmentTitle'],
      service: json['service'],
      startTime: json['startTime'],
      duration: json['duration'],
      totalPrice: json['totalPrice'],
      sellerToken: json['sellerToken'],
      technicianToken: json['technicianToken'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointmentTitle': appointmentTitle,
      'service': service,
      'startTime': startTime,
      'duration': duration,
      'totalPrice': totalPrice,
      'sellerToken': sellerToken,
      'technicianToken': technicianToken,
      'status': status,
    };
  }
}

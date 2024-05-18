
import 'dart:math';

class OrderTracking {
  final String token;
  final String orderId;
  final String customerName;
  final String customerEmail;
  final String customerContact;
  final List<OrderItem> orderItems;
  final String deliveryMethod;
  final String paymentMethod;
  final String orderStatus;
  final DateTime estimatedDelivery;
  final String orderTracking;
  final DateTime orderedDate;


  OrderTracking({
    required this.customerEmail,
    required this.orderTracking,
    required this.token,
    required this.orderId,
    required this.customerName,
    required this.customerContact,
    required this.orderItems,
    required this.deliveryMethod,
    required this.paymentMethod,
    required this.orderStatus,
    required this.estimatedDelivery,
    required this.orderedDate,

  });


  String generateOrderId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch; // Unique timestamp
    final randomNum = random.nextInt(99999).toString().padLeft(5, '0'); // Random 5-digit number

    // Combine a prefix with a timestamp and random number
    return 'ORD$timestamp$randomNum';
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'orderId': orderId,
      'customerName': customerName,
      'customerContact': customerContact,
      'orderItems': orderItems.map((item) => item.toJson()).toList(),
      'deliveryMethod': deliveryMethod,
      'paymentMethod': paymentMethod,
      'orderStatus': orderStatus,
      'estimatedDelivery': estimatedDelivery.toIso8601String(),
      'orderedDate':orderedDate.toIso8601String(),
      'customerEmail':customerEmail
    };
  }
}

class OrderItem {
  final int storeId;
  final String productName;
  final String description;
  final double price;
  final int quantity;
  final String orderTracking;

  OrderItem({
    required this.storeId,
    required this.productName,
    required this.description,
    required this.price,
    required this.quantity,
    required this.orderTracking,

  });

  Map<String, dynamic> toJson() {
    return {
      'storeId':storeId,
      'productName': productName,
      'description': description,
      'price': price,
      'quantity': quantity,
      'orderTracking':orderTracking
    };
  }
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      storeId: json['storeId'] as int,
      orderTracking: json['orderTracking'] as String,
      productName: json['productName'] as String,
      price: json['price'] as double,
      quantity: json['quantity'] as int, description: '',
    );
  }
}




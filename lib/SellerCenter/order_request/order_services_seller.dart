import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../OrderTracking/Order.dart';
import '../../Utilities/constant.dart';
import '../../main.dart';

Future<List<String>> fetchOrderItemsByProductNames() async {
  uniqueOrderIds = {};

  for (String productName in productNames) {
    final url = Uri.parse('${serverBaseUrl}order-items/get-by-productName?productName=$productName');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);

      for (var orderId in jsonResponse) {
        if (orderId is String) {
          uniqueOrderIds.add(orderId); // Adds only unique order IDs
        }
      }
    }
    else if(response.body.isEmpty){
      continue;
    }
    else {
      throw Exception('Failed to fetch order items for product: $productName');
    }
  }
  for(String uniqueIDs in uniqueOrderIds){
    print(uniqueIDs);
  }
  isFetchByNameCompleted=true;

  return uniqueOrderIds.toList(); // Convert the Set back to a List before returning
}

Future<List<OrderTracking>> fetchOrdersByOrderIds() async {
  List<OrderTracking> orders = [];

  for (String orderId in uniqueOrderIds) {
    final response = await http.get(
      Uri.parse('${serverBaseUrl}orders/getByOrderId?orderId=$orderId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      orders.addAll(data.map((json) {
        return OrderTracking(
          orderId: json['orderId'],
          customerName: json['customerName'],
          customerContact: json['customerContact'],
          orderStatus: json['orderStatus'],
          deliveryMethod: json['deliveryMethod'],
          paymentMethod: json['paymentMethod'],
          estimatedDelivery: DateTime.parse(json['estimatedDelivery']),
          orderedDate: DateTime.parse(json['orderedDate']),
          orderItems: (json['orderItems'] as List).map((item) {
            return OrderItem(
              storeId: item['storeId'],
              productName: item['productName'],
              price: item['price'],
              quantity: item['quantity'],
              orderTracking: json['orderId'],
              description: '',
            );
          }).toList(),
          orderTracking: json['orderId'],
          token: json['token'],
          customerEmail: json['customerEmail'] ,
        );
      }).toList());
    } else {
      throw Exception('Failed to fetch orders for orderId: $orderId');
    }
  }

  return orders; // Return the list of detailed orders
}

Future<void> updateOrderTracking(String orderId,String orderStatus) async {
  final url = '${serverBaseUrl}orders/updateByOrderId';
  final response = await http.put(
    Uri.parse('$url?orderId=$orderId'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(
        {
          "orderStatus":orderStatus
        }
    ),  // Sending updateData as the body content
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update order tracking');
  }

}

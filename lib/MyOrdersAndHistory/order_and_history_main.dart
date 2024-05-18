import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';
import 'package:hatbazarsample/main.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../OrderTracking/Order.dart';
import '../OrderTracking/order_tracking_dart.dart';
import '../Utilities/colors.dart';
import '../Widgets/bigText.dart';
import '../Widgets/smallText.dart';
import 'order_timeline.dart';

class OrderAndHistoryMainPage extends StatefulWidget {
  const OrderAndHistoryMainPage({Key? key}) : super(key: key);

  @override
  State<OrderAndHistoryMainPage> createState() => _OrderAndHistoryMainPageState();
}

enum OrderFilter { completed, pending, all, approved, shipping }

class _OrderAndHistoryMainPageState extends State<OrderAndHistoryMainPage> {
  OrderFilter _currentFilter = OrderFilter.all;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  bool _isLoading = true; // Loading state
  List<OrderTracking> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final response = await http.get(
      Uri.parse('${serverBaseUrl}orders/get?token=$token'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Map data to OrderTracking objects
      List<OrderTracking> fetchedOrders = data.map((json) {
        return OrderTracking(
          orderId: json['orderId'],
          customerName: json['customerName'],
          customerEmail: json['customerEmail'],
          customerContact: json['customerContact'],
          orderStatus: json['orderStatus'],
          deliveryMethod: json['deliveryMethod'],
          paymentMethod: json['paymentMethod'],
          estimatedDelivery: DateTime.parse(json['estimatedDelivery']),
          orderedDate: DateTime.parse(json['orderedDate']),
          token: json['token'],
          orderItems: (json['orderItems'] as List).map((item) {
            return OrderItem(
              storeId: item['storeId'],
              productName: item['productName'],
              description: item['description'],
              price: item['price'],
              quantity: item['quantity'],
              orderTracking: json['orderId'],
            );
          }).toList(), orderTracking: json['orderId'],
        );
      }).toList();

      setState(() {
        _orders = fetchedOrders;
        _isLoading = false;
      });
    }else if(
    response.body.isEmpty
    ){
      setState(() {
        _isLoading = false;
      });
        print("no data availale");

    }
    else {
      throw Exception('Failed to fetch orders');
    }
  }

  List<OrderTracking> get _filteredOrders {
    switch (_currentFilter) {
      case OrderFilter.completed:
        return _orders.where((order) => order.orderStatus == 'Completed').toList();
      case OrderFilter.pending:
        final List<String> pendingStatuses = ['Processing','Completion_Requested'];
        return _orders.where((order) => pendingStatuses.contains(order.orderStatus)).toList();
      case OrderFilter.approved:
        return _orders.where((order) => order.orderStatus == 'Approved').toList();
      case OrderFilter.shipping:
        return _orders.where((order) => order.orderStatus == 'Shipping').toList();
      default:
        return _orders;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order and History", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        leading: GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, 'homePage');
            },
            child: const Icon(Icons.arrow_back,color: Colors.white,)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : _orders.isEmpty
          ? Center(child: Text("There are no order history for now"))
          : Container(
        color: AppColors.backgroundColor,
        child: Column(
          children: [
            SizedBox(height: ResponsiveDim.height10),
            // Filter buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton(OrderFilter.all, "All", 85),
                _buildFilterButton(OrderFilter.pending, "Pending", 120),
                _buildFilterButton(OrderFilter.completed, "Completed", 145),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton(OrderFilter.approved, "Approved", 180),
                _buildFilterButton(OrderFilter.shipping, "Shipping", 180),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = _filteredOrders[index];
                  return _buildOrderCard(order);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(OrderFilter filter, String text, double width) {
    final isActive = _currentFilter == filter;
    return CustomButton(
      buttonText: text,
      onPressed: () => setState(() => _currentFilter = filter),
      color: isActive ? Colors.green : Colors.grey,
      height: 45,
      width: width,
    );
  }

  Widget _buildOrderCard(OrderTracking order) {
    final totalPrice = order.orderItems.fold(
      0.0,
          (sum, item) => sum + item.price * item.quantity,
    );

    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BigText(
              text: "Order ID: ${order.orderId}",
              color: Colors.black,
              size: 20,
              weight: FontWeight.bold,
            ),
            SizedBox(height: 8),
            BigText(
              text: "Ordered Date: ${_dateFormat.format(order.orderedDate)}",
              size: 17,
            ),
            BigText(text: "Items:", size: 18),
            SizedBox(height: 5,),
            Container(
              height: 100,
              child: ListView.builder(
                itemCount: order.orderItems.length,
                itemBuilder: (context, index) {
                  final item = order.orderItems[index];
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ListTile(
                      title: Text(
                        "${item.productName} x${item.quantity}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text("Rs. ${item.price}"),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 15,),
            BigText(text: "Bill Amount: Rs $totalPrice", size: 17, color: Colors.red),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  buttonText: "Summary",
                  width: ResponsiveDim.screenWidth / 2.8,
                  height: 50,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderTrackingPage(order: order),
                      ),
                    );
                  },
                ),
                CustomButton(
                  buttonText: "Tracking",
                  width: ResponsiveDim.screenWidth / 2.7,
                  color: Colors.red,
                  height: 50,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderTimelineScreen(orderId: order.orderId),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getOrderItemsDescription(List<OrderItem> orderItems) {
    return orderItems.map((item) => "${item.productName} x${item.quantity}").join("\n ");
  }
}


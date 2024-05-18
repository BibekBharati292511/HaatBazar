import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/MyOrdersAndHistory/order_timeline.dart';
import 'package:hatbazarsample/SellerCenter/Tools/seller_tools.dart';
import 'package:intl/intl.dart';

import '../../OrderTracking/Order.dart';
import '../../OrderTracking/order_tracking_dart.dart';
import '../../Utilities/ResponsiveDim.dart';
import '../../Utilities/colors.dart';
import '../../Widgets/bigText.dart';
import '../../Widgets/custom_button.dart';
import '../../main.dart';
import 'order_services_seller.dart';

class orderRequest extends StatefulWidget {
  const orderRequest({super.key});

  @override
  State<orderRequest> createState() => _orderRequestState();

}
enum OrderFilter { completed, pending, all, approved, shipping }

class _orderRequestState extends State<orderRequest> {
  OrderFilter _currentFilter = OrderFilter.all;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  List<OrderTracking> _orders = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchOrderData(); 
  }

  Future<void> fetchOrderData() async {
    isFetchByNameCompleted=false;
    try {
      List<String> orderIds = await fetchOrderItemsByProductNames();
      if (isFetchByNameCompleted) {
        List<OrderTracking> fetchedOrders = await fetchOrdersByOrderIds();
        setState(() {
          _orders = fetchedOrders;
          _isLoading = false;
        });
      }
    }catch (e) {
      print('Error: $e');
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
        title: const Text("Order Tracking", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        leading: GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, 'sellerHomePage');
            },
            child: const Icon(Icons.arrow_back,color: Colors.white,)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Loading indicator
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BigText(
                text: " ${_getOrderItemsDescription(order.orderItems)}",
                size: 17,
              ),
            ),
            BigText(text: "Bill Amount: Rs $totalPrice", size: 17, color: Colors.red),
            SizedBox(height: 16),
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

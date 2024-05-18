import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:hatbazarsample/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';
import 'package:hatbazarsample/Widgets/smallText.dart';

import '../AddToCart/Cart_Item.dart';
import '../AddToCart/add_to_cart_page.dart';
import '../AddToCart/cart_controller.dart';
import '../OrderTracking/Order.dart';
import '../OrderTracking/order_tracking_dart.dart';
import '../OrderTracking/store_order_tracking.dart';
import '../Utilities/ResponsiveDim.dart';

class IndividualCheckOut extends StatefulWidget {
  @override
  _IndividualCheckOutState createState() => _IndividualCheckOutState();
}

class _IndividualCheckOutState extends State<IndividualCheckOut> {
  final CartController cartController = Get.find();
  bool isLoading = true;
  Map<int, List<String>> storeDeliveryOptions = {};
  Map<int, List<String>> storePaymentOptions = {};
  Map<int, String> selectedDelivery = {};
  Map<int, String> selectedPayment = {};

  @override
  void initState() {
    super.initState();
    fetchOptionsForAllStores();
  }

  Future<void> fetchOptionsForAllStores() async {
    try {
      var storeIds = cartController.cartItems.map((item) => item.storeIdUser!).toSet();
      for (var storeId in storeIds) {
        storeDeliveryOptions[storeId] = await fetchDeliveryOptions(storeId);
        storePaymentOptions[storeId] = await fetchPaymentOptions(storeId);
        selectedDelivery[storeId] = storeDeliveryOptions[storeId]!.first;
        selectedPayment[storeId] = storePaymentOptions[storeId]!.first;
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching options: $e');
    }
  }

  double parsePrice(String price) {
    String cleanedPrice = price.replaceAll(RegExp(r'[^0-9].'), '');
    return double.tryParse(cleanedPrice) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Individual Checkout", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        toolbarHeight: 50,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("This page was displayed to you because you have ordered product from multiple stores.\n Due to this, order tracking and further process will be divided."),
              ),
              Expanded(
                child: ListView.builder(
                        itemCount: storeDeliveryOptions.keys.length,
                        itemBuilder: (context, index) {
                int storeId = storeDeliveryOptions.keys.elementAt(index);
                String producer = cartController.cartItems.firstWhere((item) => item.storeIdUser == storeId).producer;
                
                List<CartItem> storeItems = cartController.cartItems.where((item) => item.storeIdUser == storeId).toList();
                double storeSubtotal = storeItems.fold(0, (sum, item) => sum + (parsePrice(item.price) * item.quantity));
                
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Producer: $producer",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ...storeItems.map((item) => Text(
                          "${item.productName}: ${item.price} x ${item.quantity}",
                        )),
                        const SizedBox(height: 10),
                        Text(
                          "Subtotal: Rs ${storeSubtotal.toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        const Text("Choose your delivery option:"),
                        DropdownButton<String>(
                          value: selectedDelivery[storeId],
                          items: storeDeliveryOptions[storeId]!.map((option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedDelivery[storeId] = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        const Text("Choose your payment option:"),
                        DropdownButton<String>(
                          value: selectedPayment[storeId],
                          items: storePaymentOptions[storeId]!.map((option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedPayment[storeId] = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          buttonText: "Checkout for $producer",
                          width: ResponsiveDim.screenWidth,
                          onPressed: () async {
                            final List<int?> cartIds = storeItems.map((item) => item.cartItemId).toList();
                            orderId = generateOrderId();
                            final orderTracking = OrderTracking(
                              orderedDate: DateTime.now(),
                              orderTracking: orderId,
                              customerEmail: userEmail!,
                              token: token,
                              orderId: orderId,
                              customerName: name,
                              customerContact: phone,
                              orderItems: cartItemsToOrderItems(storeItems.obs),
                              deliveryMethod: selectedDelivery[storeId]!,
                              paymentMethod: selectedPayment[storeId]!,
                              orderStatus: 'Processing',
                              estimatedDelivery: DateTime.now().add(const Duration(days: 5)),
                            );
                            try {
                              await storeOrderInDatabase(orderTracking, context);
                              showSuccessDialog(context, "Your order for $producer is processing.");
                              for(var cardId in cartIds){
                                print(cardId);
                              }
                              print(cartIds);
                             await cartController.deleteCartItemsByCartIdsAndUserId(cartIds);
                              setState(() {
                                storeDeliveryOptions.remove(storeId);
                                storePaymentOptions.remove(storeId);
                                selectedDelivery.remove(storeId);
                                selectedPayment.remove(storeId);
                              });
                            } catch (error) {
                              debugPrint('Error placing order: $error');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
                        },
                      ),
              ),
            ],
          ),
    );
  }

  Future<List<String>> fetchDeliveryOptions(int storeId) async {
    final response = await http.get(
      Uri.parse('${serverBaseUrl}storeDeliveryOptions/DeliveryOptionsByStored?store_id=$storeId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((option) => option['deliveryOptions'].toString()).toList();
    } else {
      throw Exception('Failed to load delivery options');
    }
  }

  Future<List<String>> fetchPaymentOptions(int storeId) async {
    final response = await http.get(
      Uri.parse('${serverBaseUrl}storePaymentOptions/getPaymentOptionsByStoreId?store_id=$storeId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((option) => option['paymentOptions'].toString()).toList();
    } else {
      throw Exception('Failed to load payment options');
    }
  }

  void showSuccessDialog(BuildContext context, String message, {String buttonText = "OK"}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Order Placed"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }
}

import 'dart:math';

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

import '../CheckOut/inidividual Checkout.dart';
import '../Notification/push_notification_trial.dart';
import '../OrderTracking/Order.dart';
import '../OrderTracking/order_tracking_dart.dart';
import '../OrderTracking/store_order_tracking.dart';
import '../Utilities/ResponsiveDim.dart';
import 'Cart_Item.dart';
import 'cart_controller.dart';


String generateOrderId() {
  final random = Random();
  final timestamp = DateTime.now().millisecondsSinceEpoch; // Unique timestamp
  final randomNum = random.nextInt(99999).toString().padLeft(5, '0'); // Random 5-digit number
  return 'ORD$timestamp$randomNum';
}
late String orderId;
List<OrderItem> cartItemsToOrderItems(RxList<CartItem> cartItems) {
  return cartItems.map((cartItem) {
    String sanitizedPrice = RegExp(r'[0-9]+').stringMatch(cartItem.price) ?? '0.0';
    return OrderItem(
      storeId: cartItem.storeIdUser!,
      orderTracking: orderId,
      productName: cartItem.productName,
      description: '',
      price:double.parse(sanitizedPrice),
      quantity: cartItem.quantity,


    );
  }).toList();
}


int? idStore;

class AddToCartPage extends StatefulWidget {
  @override
  _AddToCartPageState createState() => _AddToCartPageState();
}

class _AddToCartPageState extends State<AddToCartPage> {
  final CartController cartController = Get.find();

  List<String> deliveryOptions = [];
  List<String> paymentOptions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOptions();
  }

  Future<void> fetchOptions() async {
    try {
      var fetchedDeliveryOptions = await fetchDeliveryOptions();
      var fetchedPaymentOptions = await fetchPaymentOptions();
      setState(() {
        deliveryOptions = fetchedDeliveryOptions;
        paymentOptions = fetchedPaymentOptions;
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
        title: const Text("Shopping Cart", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        toolbarHeight: 50,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          Obx(() => Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  // Navigate to the cart screen
                  Get.toNamed('/cart');
                },
              ),
              if (cartController.cartItemCount.value > 0)
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      cartController.cartItemCount.value.toString(),
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          )),
          SizedBox(width: 15),
        ],
      ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
        child: Obx(() {
      if (cartController.cartItems.isEmpty) {
        return const Center(child: Text("Your cart is empty"));
      }
      idStore = cartController.cartItems.first.storeIdUser;
      print('Store ID: $idStore');

      // Group items by store and store producer name
      Map<int, List<CartItem>> groupedItems = {};
      Map<int, String> storeProducers = {};
      for (var item in cartController.cartItems) {
        if (!groupedItems.containsKey(item.storeIdUser)) {
          groupedItems[item.storeIdUser!] = [];
          storeProducers[item.storeIdUser!] = item.producer;
        }
        groupedItems[item.storeIdUser]!.add(item);
      }

      return Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 15),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  var item = cartController.cartItems[index];

                  return Card(
                    elevation: 4,
                    child: ListTile(
                      leading: Container(
                        height: ResponsiveDim.height310,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ResponsiveDim.radius6),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(item.imageBytes),
                          ),
                        ),
                      ),
                      title: BigText(text: item.productName, size: 20),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SmallText(text: "${item.description}", color: Colors.blueAccent),
                          SmallText(text: "Price: ${item.price}", color: Colors.black),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (item.quantity > 1) {
                                cartController.updateQuantity(item, item.quantity - 1);
                              } else {
                                cartController.removeFromCart(item);
                              }
                            },
                          ),
                          BigText(text: item.quantity.toString()),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              cartController.updateQuantity(item, item.quantity + 1);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              cartController.removeFromCart(item);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Bill Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ...groupedItems.entries.map((entry) {
                      int storeId = entry.key;
                      String producer = storeProducers[storeId] ?? '';
                      List<CartItem> items = entry.value;

                      double subtotal = items.fold(0,
                              (sum, item) => sum + (parsePrice(item.price) * item.quantity));
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Producer: $producer",
                          ),
                          ...items.map((item) => Text(
                            "${item.productName}: ${item.price} x ${item.quantity}",
                          )),
                          Text(
                            "Subtotal: Rs ${subtotal.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                    const SizedBox(height: 15),
                    Text(
                      "Total: Rs ${cartController.totalCost.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      buttonText: "Checkout",
                      onPressed: () async {
                        if(storeProducers.length>1) {
                          Get.to(() => IndividualCheckOut());
                        }
                        else {
                           await fetchOptions();
                           _showCheckoutDialog(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      );
    })));
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
              onPressed: () async {
                print("iun here rhwauruehf");
                await LocalNotifications.init();
                LocalNotifications.showSimpleNotification(
                  title: 'Order request',
                  body: 'You have got a new order request from the user',
                  payload: 'Payload from Another Page', // This payload will be sent when the notification is tapped
                );
                Navigator.pop(context);
              },
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    if (deliveryOptions.isEmpty || paymentOptions.isEmpty) {
      return;
    }

    var selectedDelivery = deliveryOptions.first;
    var selectedPayment = paymentOptions.first;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Checkout Options"),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Choose your delivery option:"),
                DropdownButton<String>(
                  value: selectedDelivery,
                  items: deliveryOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDelivery = value!;
                    });

                  },
                ),
                const SizedBox(height: 10),
                const Text("Choose your payment option:"),
                DropdownButton<String>(
                  value: selectedPayment,
                  items: paymentOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedPayment = value!;
                    setState(() {
                      selectedPayment;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                CustomButton(
                  buttonText: "Cancel",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.red,
                  width: 120,
                  height: 50,
                ),
                CustomButton(
                  buttonText: "Proceed",
                  width: 120,
                  height: 50,
                  onPressed: () async {
                    orderId = generateOrderId();
                    final orderTracking = OrderTracking(
                      orderedDate: DateTime.now(),
                      orderTracking: orderId,
                      customerEmail: userEmail!,
                      token: token,
                      orderId: orderId,
                      customerName: name,
                      customerContact: phone,
                      orderItems: cartItemsToOrderItems(cartController.cartItems),
                      deliveryMethod: selectedDelivery,
                      paymentMethod: selectedPayment,
                      orderStatus: 'Processing',
                      estimatedDelivery: DateTime.now().add(const Duration(days: 5)),
                    );
                    try {
                      await storeOrderInDatabase(orderTracking, context);
                    } catch (error) {
                      debugPrint('Error placing order: $error');
                    }
                    Navigator.pop(context);
                    showSuccessDialog(context, "Your product is processing for checkout");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderTrackingPage(order: orderTracking),
                      ),
                    );
                    cartController.removeAllFromCart();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<List<String>> fetchDeliveryOptions() async {
    final response = await http.get(
      Uri.parse('${serverBaseUrl}storeDeliveryOptions/DeliveryOptionsByStored?store_id=$idStore'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((option) => option['deliveryOptions'].toString()).toList();
    } else {
      throw Exception('Failed to load delivery options');
    }
  }

  Future<List<String>> fetchPaymentOptions() async {
    final response = await http.get(
      Uri.parse('${serverBaseUrl}storePaymentOptions/getPaymentOptionsByStoreId?store_id=$idStore'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((option) => option['paymentOptions'].toString()).toList();
    } else {
      throw Exception('Failed to load payment options');
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../AddToCart/cart_controller.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final CartController cartController = Get.find<CartController>();
  final List<String> deliveryOptions = ["Standard", "Express"];
  final List<String> paymentOptions = ["Credit Card", "PayPal", "Cash on Delivery"];

  String selectedDelivery = "Standard";
  String selectedPayment = "Credit Card";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Cart",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  var item = cartController.cartItems[index];
                  return ListTile(
                    title: Text(item.productName ?? "Product"),
                    subtitle: Text("Price: ${item.price}, Qty: ${item.quantity}"),
                    trailing: Text(
                      "Subtotal: ${(double.tryParse(item.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0) * item.quantity}",
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Text(
              "Total Cost: ${cartController.totalCost}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("Select Delivery Method"),
            DropdownButton<String>(
              value: selectedDelivery,
              onChanged: (String? newValue) {
                setState(() {
                  selectedDelivery = newValue ?? selectedDelivery;
                });
              },
              items:  deliveryOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text("Select Payment Method"),
            DropdownButton<String>(
              value: selectedPayment,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPayment = newValue ?? selectedPayment;
                });
              },
              items: paymentOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Proceed to checkout
                  _proceedToCheckout(context, selectedDelivery, selectedPayment);
                },
                child: Text("Proceed to Checkout"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _proceedToCheckout(BuildContext context, String delivery, String payment) {
    // Handle the checkout process
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Order Confirmation"),
          content: Text(
            "Your order has been placed with delivery method: $delivery and payment method: $payment.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Return to the previous page
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

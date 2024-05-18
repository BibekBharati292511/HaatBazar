import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

import '../main.dart';
import 'Cart_Item.dart';
import 'package:hatbazarsample/Utilities/constant.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  final String baseUrl = '${serverBaseUrl}cart/';
  final String userId = token;
  var cartItemCount = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
    fetchCartItemCount();

  }

  Future<void> fetchCartItemCount() async {
    final response = await http.get(Uri.parse('${baseUrl}count?userId=$userId'));
    if (response.statusCode == 200) {
      cartItemCount.value = int.parse(response.body);
    } else {
      print('Failed to fetch cart item count');
    }
  }

  Uint8List base64ToImage(String base64String) {
    return base64Decode(base64String);
  }
  Future<void> fetchCartItems() async {
    print("user data here");
    print(userId);
    final response = await http.get(Uri.parse('${baseUrl}userId?userId=$userId'));
    if (response.statusCode == 200) {
      List<dynamic> cartData = jsonDecode(response.body);
      cartItems.value = cartData.map((item) => CartItem(
          producer: item['producer'],
          productName: item['productName'],
          description: item['description'] ?? '',
          price: item['price'],
          quantity: item['quantity'],
          imageBytes: base64ToImage(item['image'],),
          storeIdUser:item["store_id"],
          cartItemId: item['id']
      )).toList();
    } else {
      // Handle error
      print('Failed to load cart items');
    }
  }
  String imageToBase64(Uint8List imageBytes) {
    return base64Encode(imageBytes);
  }
  Future<void> addToCart(CartItem item, BuildContext context) async {
    String base64Image = imageToBase64(item.imageBytes);
    var existingIndex = cartItems.indexWhere(
          (i) => i.productName == item.productName,
    );

    if (existingIndex >= 0) {
      await updateQuantity(cartItems[existingIndex], cartItems[existingIndex].quantity + item.quantity);
    } else {
      final response = await http.post(
        Uri.parse('${baseUrl}add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'producer':item.producer,
          'userId': userId,
          'productName': item.productName,
          'description': item.description,
          'price': item.price,
          'quantity': item.quantity,
          'store_id':item.storeIdUser,
          'image':base64Image
        }),
      );
      if (response.statusCode == 200) {
        cartItems.add(item);
        _showAddToCartDialog(context, item.productName);
      } else {
        // Handle error
        print('Failed to add item to cart');
      }
    }
    fetchCartItems();
    fetchCartItemCount();
  }

  Future<void> updateQuantity(CartItem item, int quantity) async {
    final response = await http.put(
      Uri.parse('${baseUrl}cartItemId/quantity?cartItemId=${item.cartItemId}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(quantity),

    );


    if (response.statusCode == 200) {
      item.quantity = quantity;
      cartItems.refresh();
    } else {
      print('Failed to update quantity');
    }
    fetchCartItems();
    fetchCartItemCount();
  }

  // Future<void> removeFromCart(CartItem item) async {
  //   final response = await http.delete(Uri.parse('${baseUrl}${item.productName}'));
  //   if (response.statusCode == 204) {
  //     cartItems.remove(item);
  //   } else {
  //     print('Failed to remove item from cart');
  //   }
  // }
  Future<void> removeFromCart(CartItem item) async {
    print(item.cartItemId);
    final response = await http.delete(
        Uri.parse('${baseUrl}cartItemId?cartItemId=${item.cartItemId}'),
    );

    if (response.statusCode == 200) {
      print("runninf");
      cartItems.remove(item);
    } else {
      print(response.statusCode);
      print('Failed to remove item from cart');
    }
    fetchCartItems();
    fetchCartItemCount();
  }
  Future<void> removeAllFromCart() async {
    final response = await http.delete(
      Uri.parse('${baseUrl}deleteByUser?userId=$token'),
    );

    if (response.statusCode == 200) {
      fetchCartItems();
      fetchCartItemCount();
    } else {
      print('Failed to remove item from cart');
    }

  }
  Future<void> deleteCartItemsByCartIdsAndUserId(List<int?> cartIds) async {
    try {
      final response = await http.delete(
        Uri.parse('${baseUrl}deleteByCartIdsAndUser?cartIds=${cartIds.join(',')}&userId=$token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        fetchCartItems();
        fetchCartItemCount();
        print('Cart items deleted successfully');
      } else {
        print('Failed to delete cart items: ${response.statusCode}');
      }

      // Handle response as needed...
    } catch (e) {
      print('Error: $e');
    }
  }




  void _showAddToCartDialog(BuildContext context, String? productName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Product Added"),
          content: Text("$productName has been added to your cart."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
    fetchCartItems();
    fetchCartItemCount();
  }

  double get totalCost {
    double total = 0;
    for (var item in cartItems) {
      String sanitizedPrice = item.price.replaceAll(RegExp(r'[^0-9].'), '');
      double parsedPrice = double.tryParse(sanitizedPrice) ?? 0.0;
      total += parsedPrice * item.quantity;
    }
    return total;
  }
}

import 'dart:typed_data';

class CartItem {
  final int? cartItemId;
  final String productName;
  final String description;
  final String price;
  final int? storeIdUser;
  int quantity;
  final Uint8List imageBytes;
  final String producer;

  CartItem({
    this.cartItemId,
    this.storeIdUser,
    required this.imageBytes,
    required this.productName,
    required this.description,
    required this.producer,
    required this.price,
    this.quantity = 1,
  });
}

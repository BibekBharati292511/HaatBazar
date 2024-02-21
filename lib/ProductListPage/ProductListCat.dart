import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/ProductCard/bigProductCardWidget.dart';

import '../Utilities/ResponsiveDim.dart';
import '../Utilities/colors.dart';
import '../Widgets/smallText.dart';

class ProductListCat extends StatefulWidget {
  const ProductListCat({Key? key}) : super(key: key);

  @override
  State<ProductListCat> createState() => _ProductListCatState();
}

class _ProductListCatState extends State<ProductListCat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.backgroundColor,
        padding: EdgeInsets.only(top: ResponsiveDim.height45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context); // Navigate back
                  },
                ),
                GestureDetector(
                  onTap: () {
                    print("Tapped");
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: ResponsiveDim.radius6),
                    alignment: Alignment.centerLeft,
                    height: ResponsiveDim.icon44,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: SmallText(
                            text: "Daily Consumable items",
                            color: Colors.black54,
                            overFlow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.search,
                          size: ResponsiveDim.icon24,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: ResponsiveDim.width10),
                      child: Icon(
                        Icons.shopping_cart,
                        color: AppColors.primaryButtonColor,
                        size: ResponsiveDim.icon44,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: ResponsiveDim.width20),
                      child: Icon(
                        Icons.filter_alt_rounded,
                        color: AppColors.primaryButtonColor,
                        size: ResponsiveDim.icon44,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: ResponsiveDim.height10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ProductCardBigWidget(
                      productName: 'Pukhreli Orange',
                      description: 'A heavenly delight that captures the essence of delightful food.',
                      price: 'Rs. 100 /Kg',
                      rating: 4.5,
                      reviewCount: 32,
                      producer: 'Narayani Agro Farm',
                      imagePath: 'assets/images/orange.png',
                    ),
                    ProductCardBigWidget(
                      productName: 'Desi Potatoes',
                      description: 'A heavenly delight that captures the essence of delightful food.',
                      price: 'Rs. 80 /Kg',
                      rating: 5,
                      reviewCount: 25,
                      producer: 'Hamro Krisi Farm',
                      imagePath: 'assets/images/productImage/potato.png',
                    ),
                    ProductCardBigWidget(
                      productName: 'Mango',
                      description: 'A heavenly delight that captures the essence of delightful food.',
                      price: 'Rs. 150 /Kg',
                      rating: 4,
                      reviewCount: 352,
                      producer: 'Pushpa Krishi Udhyog',
                      imagePath: 'assets/images/productImage/mango.png',
                    ),
                    ProductCardBigWidget(
                      productName: 'Buff meet',
                      description: 'A heavenly delight that captures the essence of delightful food.',
                      price: 'Rs. 1500 /Kg',
                      rating: 5,
                      reviewCount: 352,
                      producer: 'Pushpa Krishi Udhyog',
                      imagePath: 'assets/images/productImage/meet.png',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';
import 'package:hatbazarsample/Widgets/smallText.dart';

import '../ProductListPage/ProductListCat.dart';

class Product {
  final String name;
  final String imagePath;
  final double rating;
  final String price;

  Product({required this.name, required this.imagePath, required this.rating, required this.price});
}

class ProductWidget extends StatelessWidget {
  final List<Product> products; // This list would be populated from the backend

  const ProductWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];

    for (int i = 0; i < products.length; i += 2) {
      // Create a row with at most 2 columns
      List<Widget> columns = [];

      for (int j = i; j < i + 2 && j < products.length; j++) {
        columns.add(
          Expanded(
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductListCat(),
                  ),
                );
                print("tapped");
              },
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: ResponsiveDim.width30),
                    decoration: BoxDecoration(
                      color:  const Color(0xB7F8F5EF),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: ResponsiveDim.screenHeight / 5.5,
                          height: ResponsiveDim.screenHeight / 5.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(ResponsiveDim.radius15),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(products[j].imagePath),
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveDim.screenHeight / 445.142),
                        BigText(
                          text: products[j].name,
                          wrap: true,
                        ),
                        Row(
                          children: [
                            Wrap(
                              children: [
                                // Filled stars for the integer part
                                ...List.generate(
                                  products[j].rating.toInt(),
                                      (index) => Icon(Icons.star, color: Colors.cyan, size: ResponsiveDim.height15),
                                ),
                                // Partially filled star for the decimal part
                                if (products[j].rating % 1 > 0) // Check if there is a decimal part
                                  Icon(
                                    Icons.star_half,
                                    color: Colors.cyan,
                                    size: ResponsiveDim.height15,
                                  ),
                                // Empty stars for the remaining part (if any)
                                ...List.generate(
                                  (5 - products[j].rating).toInt(), // Assuming a total of 5 stars
                                      (index) => Icon(Icons.star_border, color: Colors.cyan, size: ResponsiveDim.height15),
                                ),
                              ],
                            ),

                            SizedBox(width: ResponsiveDim.width10),
                            SmallText(text: "${products[j].rating}/5"),
                            SizedBox(width: ResponsiveDim.width10),
                          ],
                        ),
                        BigText(
                          text: 'Rs ${products[j].price} /kg',
                          size: ResponsiveDim.height20,
                          weight: FontWeight.bold,
                          color: Colors.red,
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveDim.height15,),
                ],
              ),
            ),

          ),

        );
      }

      // Add the row to the list of rows
      rows.add(
        Row(
          children: columns,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Other scrollable content above the product cards
        ...rows,


      ],
    );
  }
}

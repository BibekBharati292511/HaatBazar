import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/AddToCart/cart_controller.dart';
import 'package:hatbazarsample/Services/get_imageBy_product_name.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';
import 'package:hatbazarsample/ProductListPage/ProductListCat.dart'; // Import your product list page
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/ProductCard/product.dart';
import 'package:hatbazarsample/Services/get_product_by_storeID.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';

import '../../main.dart';

class SellerLandingPage extends StatefulWidget {
  const SellerLandingPage({Key? key});

  @override
  State<SellerLandingPage> createState() => _SellerLandingPageState();
}

class _SellerLandingPageState extends State<SellerLandingPage> {
int indexes=productLists.length;
  @override
  void initState() {
    super.initState();


  }


  @override
  Widget build(BuildContext context) {
  print(indexes);
    return Container(
      color: AppColors.backgroundColor,
      child: Padding(
        padding:  EdgeInsets.only(left: ResponsiveDim.width15,right: ResponsiveDim.width5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ResponsiveDim.height5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BigText(text: 'My Products'),
                CustomButton(buttonText: 'Add More', onPressed: (){
                  Navigator.pushNamed(context, 'addProduct');
                },width: ResponsiveDim.width150,height: ResponsiveDim.height45,)
              ],
            ),
            SizedBox(height: ResponsiveDim.height10),
            for (int i = 0; i < indexes; i ++)

              Column(
                children: [
                  ProductWidget(products: productLists[i]),

                  SizedBox(height: ResponsiveDim.height15),
                ],

              ),
            SizedBox(height: ResponsiveDim.height10,),
            BigText(text: "Sales Report"),
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    print("Tapped");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ResponsiveDim.radius8)
                      ),
                      child: Padding(
                        padding:EdgeInsets.only(left: ResponsiveDim.width10,right: ResponsiveDim.width10,top: ResponsiveDim.height5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.data_exploration,color: Colors.red,),
                                SizedBox(width: ResponsiveDim.width10,),
                                BigText(text: "Revenue")
                              ],
                            ),
                            Row(
                              children: [
                                BigText(text: "--"),
                                Icon(Icons.arrow_drop_up,color: Colors.green,),
                                Text('--',style: TextStyle(color: Colors.green),)
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ResponsiveDim.radius8)
                      ),
                      child: Padding(
                        padding:EdgeInsets.only(left: ResponsiveDim.width10,right: ResponsiveDim.width10,top: ResponsiveDim.height5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.shopping_bag,color: Colors.red,),
                                SizedBox(width: ResponsiveDim.width10,),
                                BigText(text: "Total Orders",size: ResponsiveDim.font24,)
                              ],
                            ),
                            Row(
                              children: [
                                BigText(text: "--"),
                                Icon(Icons.arrow_drop_up,color: Colors.green,),
                                Text('--',style: TextStyle(color: Colors.green),)
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap:(){

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ResponsiveDim.radius8)
                      ),
                      child: Padding(
                        padding:EdgeInsets.only(left: ResponsiveDim.width10,right: ResponsiveDim.width10,top: ResponsiveDim.height5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.attach_money,color: Colors.red,),
                                SizedBox(width: ResponsiveDim.width10,),
                                BigText(text: "Total Sales",size: 17,)
                              ],
                            ),
                            Row(
                              children: [
                                BigText(text: "--"),
                                Icon(Icons.arrow_drop_up,color: Colors.green,),
                                Text('- -',style: TextStyle(color: Colors.green),)
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap:(){},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ResponsiveDim.radius8)
                      ),
                      child: Padding(
                        padding:EdgeInsets.only(left: ResponsiveDim.width10,right: ResponsiveDim.width10,top: ResponsiveDim.height5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.shopping_bag,color: Colors.red,),
                                SizedBox(width: ResponsiveDim.width10,),
                                BigText(text: "Total Orders",size: ResponsiveDim.font24,)
                              ],
                            ),
                            Row(
                              children: [
                                BigText(text: "--"),
                                Icon(Icons.arrow_drop_up,color: Colors.green,),
                                Text('--',style: TextStyle(color: Colors.green),)
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveDim.height10,),
            BigText(text: "Traffic"),
            Row(
              children: [
                GestureDetector(
                  onTap: (){},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ResponsiveDim.radius8)
                      ),
                      child: Padding(
                        padding:EdgeInsets.only(left: ResponsiveDim.width10,right: ResponsiveDim.width10,top: ResponsiveDim.height5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.remove_red_eye,color: Colors.red,),
                                SizedBox(width: ResponsiveDim.width10,),
                                BigText(text: "Page View")
                              ],
                            ),
                            Row(
                              children: [
                                BigText(text: "--"),
                                Icon(Icons.arrow_drop_up,color: Colors.green,),
                                Text('--',style: TextStyle(color: Colors.green),)
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ResponsiveDim.radius8)
                      ),
                      child: Padding(
                        padding:EdgeInsets.only(left: ResponsiveDim.width10,right: ResponsiveDim.width10,top: ResponsiveDim.height5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.people_alt,color: Colors.red,),
                                SizedBox(width: ResponsiveDim.width10,),
                                BigText(text: "Visitors",size: ResponsiveDim.font24,)
                              ],
                            ),
                            Row(
                              children: [
                                BigText(text: "--"),
                                Icon(Icons.arrow_drop_up,color: Colors.green,),
                                Text('--',style: TextStyle(color: Colors.green),)
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveDim.height10,),
            BigText(text: "Conversion"),
            Row(
              children: [
                GestureDetector(
                  onTap:(){},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ResponsiveDim.radius8)
                      ),
                      child: Padding(
                        padding:EdgeInsets.only(left: ResponsiveDim.width10,right: ResponsiveDim.width10,top: ResponsiveDim.height5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.attach_money,color: Colors.red,),
                                SizedBox(width: ResponsiveDim.width10,),
                                BigText(text: "Buyers")
                              ],
                            ),
                            Row(
                              children: [
                                BigText(text: "--"),
                                Icon(Icons.arrow_drop_up,color: Colors.green,),
                                Text('--',style: TextStyle(color: Colors.green),)
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap:(){

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ResponsiveDim.radius8)
                      ),
                      child: Padding(
                        padding:EdgeInsets.only(left: ResponsiveDim.width10,right: ResponsiveDim.width10,top: ResponsiveDim.height5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.remove_red_eye,color: Colors.red,),
                                SizedBox(width: ResponsiveDim.width10,),
                                BigText(text: "Revenue per buyer",size: ResponsiveDim.smallFont,)
                              ],
                            ),
                            Row(
                              children: [
                                BigText(text: "--"),
                                Icon(Icons.arrow_drop_up,color: Colors.green,),
                                Text('--',style: TextStyle(color: Colors.green),)
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveDim.height45,),





          ],
        ),
      ),
    );
  }
}

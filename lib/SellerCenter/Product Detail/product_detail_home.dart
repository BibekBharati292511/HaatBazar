import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hatbazarsample/ProductCard/individualProductOverview.dart';
import 'package:hatbazarsample/SellerCenter/Product%20Detail/product_chart.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';
import 'package:hatbazarsample/main.dart';

import '../../AgroTechnicians/revenue_chart.dart';
import '../../Utilities/ResponsiveDim.dart';

class ProductDetail extends StatefulWidget {
  final String proName;
  const ProductDetail({super.key,required this.proName});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.backgroundColor,
        child: Column(
          children: [
           // SizedBox(height: 10,),
            AppBar(
              title: BigText(text: "Product Report",color: Colors.white,),
              backgroundColor: AppColors.primaryColor,
            ),
            SizedBox(height: ResponsiveDim.height10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BigText(text: "Product Overview"),

                      Row(
                          children: [
                             GestureDetector(
                               onTap:(){
                                 Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                     builder: (context) =>  IndividualProductOverview(productName:widget.proName),
                                   ),
                                 );
                               },
                               child:  Icon(Icons.remove_red_eye,color: Colors.redAccent,size: ResponsiveDim.height35,)
                               ,
                             ),
                            SizedBox(width: ResponsiveDim.width15,),
                            GestureDetector(
                              onTap:(){},
                              child:  Icon(Icons.edit,color: Colors.redAccent,size: ResponsiveDim.height35,)
                              ,
                            ),
                                ],
                        ),

                    ],
                  ),
                  SizedBox(height: ResponsiveDim.height20,),
                  BigText(text: "Sales Report"),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          print("Tapped");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  ProductChart(topic: "Revenue",),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RevenuePage(token:widget.proName)));
                            },
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
                  SizedBox(height: ResponsiveDim.height20,),
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
                  SizedBox(height: ResponsiveDim.height20,),
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
                  
                ],

              ),
 
            ),


          ],


        ),
      ),
    );
  }
}

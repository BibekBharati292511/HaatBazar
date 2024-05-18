import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hatbazarsample/Review/review_service.dart';
import 'package:hatbazarsample/Review/view_reviews.dart';
import 'package:hatbazarsample/SellerCenter/Technician_booking/SellerBookingHistory.dart';
import 'package:hatbazarsample/SellerCenter/Technician_booking/technician_list.dart';
import 'package:hatbazarsample/SellerCenter/order_request/order_request.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';
import 'package:hatbazarsample/main.dart';

import '../../AgroTechnicians/booking_history.dart';
import '../../Review/review_dialouge.dart';

class SellerTools extends StatefulWidget {
  const SellerTools({super.key});

  @override
  State<SellerTools> createState() => _SellerToolsState();
}

class _SellerToolsState extends State<SellerTools> {
  ReviewService service =new ReviewService();
  @override
  Widget build(BuildContext context) {
    return Container(
        width: ResponsiveDim.screenWidth,
        height: ResponsiveDim.screenHeight,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BigText(text: "Basic Functions"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, 'addProduct');
                            },
                            child: Stack(
                              children: [
                                Icon(Icons.circle, color: Colors.red[50], size: 100,),
                                const Positioned(
                                    top: 20,
                                    left: 24,
                                    child: Stack(
                                      children: [
                                        Icon(Icons.shopping_bag_outlined,size: 50,color: Colors.black54 ),
                                        Positioned(top: 17,
                                            left: 13,
                                            child: Icon(Icons.add,color: Colors.red,))
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ),
                          BigText(text: "Add Product",size: ResponsiveDim.smallFont,)
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Icon(Icons.circle, color: Colors.red[50], size: 100,),
                                const Positioned(
                                    top: 20,
                                    left: 24,
                                    child: Icon(Icons.shopping_bag,size: 50,color: Colors.red ),
                                ),
                              ],
                            ),
                            BigText(text: "products",size: ResponsiveDim.smallFont,)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>orderRequest()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Icon(Icons.circle, color: Colors.red[50], size: 100,),
                                const Positioned(
                                  top: 27,
                                  left: 25,
                                  child: Icon(Icons.remove_red_eye,size: 50,color: Colors.red ),
                                ),
                              ],
                            ),
                            BigText(text: "Orders",size: ResponsiveDim.smallFont,)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Icon(Icons.circle, color: Colors.red[50], size: 100,),
                              const Positioned(
                                  top: 24,
                                  left: 24,
                                  child:   Icon(Icons.attach_money,size: 50,color: Colors.red
                                  ),
                              ),
                            ],
                          ),
                          BigText(text: "Finance",size: ResponsiveDim.smallFont,)
                        ],
                      ),
                    ),
                    SizedBox(width: ResponsiveDim.width20,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ReviewAndRatings(ratingTo: token,)));
                        // showDialog(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return ReviewDialog(
                        //       onSubmit: (rating, comment) {
                        //         service.addReview(context: context, ratingFrom: userDataJson['firstName'], ratingTo: "908fadba-6dab-492b-ba36-a99e22faec8e",rating: rating,comment: comment);
                        //        // Navigator.push(context, MaterialPageRoute(builder: (context)=>ReviewAndRatings()));
                        //       },
                        //     );
                        //   },
                        // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Icon(Icons.circle, color: Colors.red[50], size: 100,),
                                const Positioned(
                                  top: 20,
                                  left: 24,
                                  child: Icon(Icons.star_border,size: 50,color: Colors.red ),
                                ),
                              ],
                            ),
                            BigText(text: "Reviews",size: ResponsiveDim.smallFont,)
                          ],
                        ),
                      ),
                    ),
            
                  ],
                ),
                SizedBox(height: ResponsiveDim.height35,),
                BigText(text: "Technician Booking"),
                Row(
                  children: [
                    Padding(
                      padding:  EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder:(context)=>const TechnicianList()));
                            },
                            child: Stack(
                              children: [
                                Icon(Icons.circle, color: Colors.red[50], size: 100,),
                                const Positioned(
                                  top: 20,
                                  left: 24,
                                  child:  Icon(Icons.book,size: 50,color: Colors.red ),
                                ),
                              ],
                            ),
                          ),
                          BigText(text: "Book now",size: ResponsiveDim.smallFont,),

                        ],
                      ),
                    ),
                    SizedBox(width: ResponsiveDim.width20,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SellerHistoryPage(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Icon(Icons.circle, color: Colors.red[50], size: 100,),
                                const Positioned(
                                  top: 20,
                                  left: 24,
                                  child: Icon(Icons.history,size: 50,color: Colors.red ),
                                ),
                              ],
                            ),
                            BigText(text: "Booking History",size: ResponsiveDim.smallFont,)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveDim.height35,),
                BigText(text: "Promotions"),
                Row(
                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Icon(Icons.circle, color: Colors.red[50], size: 100,),
                              const Positioned(
                                  top: 20,
                                  left: 24,
                                  child:  Icon(Icons.local_shipping_outlined,size: 50,color: Colors.red ),
                              ),
                            ],
                          ),
                          BigText(text: "Free Shipping",size: ResponsiveDim.smallFont,)
                        ],
                      ),
                    ),
                    SizedBox(width: ResponsiveDim.width20,),
                    GestureDetector(
                      onTap: (){},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Icon(Icons.circle, color: Colors.red[50], size: 100,),
                                const Positioned(
                                  top: 20,
                                  left: 24,
                                  child: Icon(Icons.card_giftcard,size: 50,color: Colors.red ),
                                ),
                              ],
                            ),
                            BigText(text: "Vouchers",size: ResponsiveDim.smallFont,)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveDim.height35,),
                BigText(text: "Social Media"),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Icon(Icons.circle, color: Colors.red[50], size: 100,),
                              const Positioned(
                                top: 22,
                                left: 22,
                                child:  Icon(Icons.facebook_outlined,size: 60,color: Colors.red ),
                              ),
                            ],
                          ),
                          BigText(text: "Link facebook",size: ResponsiveDim.smallFont,)
                        ],
                      ),
                    ),
                    SizedBox(width: ResponsiveDim.width20,),
                    GestureDetector(
                      onTap: (){
                        print(SvgPicture.asset('assets/images/icons/instaLogo.png'));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Icon(Icons.circle, color: Colors.red[50], size: 100,),
                                 Positioned(
                                  top: 23,
                                  left: 24,
                                  child: Image.asset(
                                    'assets/images/icons/instaLogo.png',
                                    width: 50,
                                    height: 50,
                                  ),
            
                                ),
                              ],
                            ),
                            BigText(text: "link Instagram",size: ResponsiveDim.smallFont,),
                            SizedBox(height: 20,),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),

    );
  }
}

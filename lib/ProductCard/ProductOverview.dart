import 'dart:convert';
import 'dart:typed_data';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/Model/UserData.dart';
import 'package:hatbazarsample/main.dart';

import '../Model/StoreAddress.dart';
import '../Review/view_reviews.dart';
import '../Utilities/ResponsiveDim.dart';
import '../Utilities/colors.dart';
import '../Utilities/iconButtonWithText.dart';
import '../Widgets/bigText.dart';
import '../Widgets/smallText.dart';

class ProductOverviewWidget extends StatefulWidget {
  final String? productName;
  final String? description;
  final String? price;
  final double? rating;
  final int? reviewCount;
  final String? producer;
  final String? highlights;
  final String? availableDate;
  final double? availableQty;
  final String? harvestedSeason;
  final List<Uint8List>? imageBytesList;

  const ProductOverviewWidget({
    Key? key,
    required this.productName,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.producer,
    required this.imageBytesList,
    required this.highlights,
    required this.availableDate,
    required this.availableQty,
    required this.harvestedSeason
  }) : super(key: key);

  @override
  _ProductOverviewWidgetState createState() => _ProductOverviewWidgetState();
}


class _ProductOverviewWidgetState extends State<ProductOverviewWidget> {
  PageController pageController = PageController(viewportFraction: 1.04);
  var _currPageValue = 0.0;
  final double _scaleFactor = 0.8;
  final double _height = ResponsiveDim.pageViewContainer;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(role=="Sellers") {
      UserDataService.fetchStoreData(token).then((storeData) {
        storeDataJson = jsonDecode(storeData);
      });
      StoreAddressService.fetchStoreAddress(storeId!).then((storeAddress) {
        storeAddressJson = jsonDecode(storeAddress);
      });
      storeAddress = storeAddressJson["address"];
    }
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        padding: EdgeInsets.only(bottom: ResponsiveDim.height10),
        decoration: BoxDecoration(
          color: AppColors.staticIconColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(ResponsiveDim.radius15),
            bottomRight: Radius.circular(ResponsiveDim.radius15),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: ResponsiveDim.height10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveDim.radius6),
              ),
              child: SizedBox(
                height: ResponsiveDim.height250,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: widget.imageBytesList?.length ?? 0, // Use length of imageBytesList
                  itemBuilder: (context, position) {
                    return _buildPageItem(position);
                  },
                ),
              ),
            ),
            DotsIndicator(
              dotsCount: widget.imageBytesList?.length ?? 0, // Use length of imageBytesList
              position: _currPageValue.round(),
              decorator: const DotsDecorator(
                color: Colors.black87,
                activeColor: Colors.redAccent,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: ResponsiveDim.width5, right: ResponsiveDim.width5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BigText(text:  '${widget.productName}'??'' ),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                    SizedBox(height: ResponsiveDim.height15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BigText(text: 'Rs ${widget.price} / $priceUnit'??'', color: Colors.red, size: ResponsiveDim.bigFont),
                        Row(
                          children: [
                            Wrap(
                              children: List.generate(
                                5,
                                    (index) => Icon(Icons.star, color: Colors.cyan, size: ResponsiveDim.height15),
                              ),
                            ),
                            SizedBox(width: ResponsiveDim.width10),
                            SmallText(text: widget.rating.toString()),
                            SizedBox(width: ResponsiveDim.width10),
                            SmallText(text: "${widget.reviewCount} Reviews"),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveDim.height15),
                    BigText(text: 'Product Highlights',weight: FontWeight.bold,),
                    Container(
                      margin: EdgeInsets.only(left: ResponsiveDim.width10, right: ResponsiveDim.width10),
                      child: Text(
                        widget.highlights??'',
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'poppins',
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: ResponsiveDim.height15),
                    BigText(text: 'Availability info',weight: FontWeight.bold,),
                    SizedBox(height: ResponsiveDim.height10,),
                    Column(
                      children: [
                        Row(
                          children: [
                            SmallText(text: 'Harvested Season:   ' ,size: 16,color: Colors.black,),
                            SmallText(text: '$harvestedSeason'??'' ,size: 16,color: Colors.black,),
                          ],
                        ),
                        Row(
                          children: [
                            SmallText(text: 'Available quantity:   ' ,size: 16,color: Colors.black,),
                            SmallText(
                              text: availableQty != null ? '$availableQty $qtyUnit' : '',
                              size: 16,
                              color: Colors.black,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SmallText(text: 'Product expires on:   ' ,size: 16,color: Colors.black,),
                            SmallText(text: '$availableDate'??'' ,size: 16,color: Colors.red,),
                          ],
                        ),

                      ],
                    ),
                    SizedBox(height: ResponsiveDim.height15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BigText(text: 'Store Location',weight: FontWeight.bold,),
                        Row(
                          children: [
                            Text('View on map'),
                            SizedBox(width: ResponsiveDim.width10,),
                            GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, 'viewAddress');

                              },
                              child: Icon(Icons.my_location,color: Colors.red,),
                            )
                          ],
                        )
                      ],
                    ),
                    Text('${storeAddress['cityDistrict']} ${storeAddress['state']} ${storeAddress['county']}'),
                    SizedBox(height: ResponsiveDim.height15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BigText(text: "Product Feedbacks:",weight: FontWeight.bold,),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Row(
                            children: [
                              SmallText(text: "View",color: Colors.blue,),
                              SizedBox(width: 5,),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ReviewAndRatings(ratingTo: widget.productName!,)));
                                },
                                child: Icon(Icons.remove_red_eye,color: Colors.red,size: 30,),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveDim.height15),
                    BigText(text: 'Description',weight: FontWeight.bold,),
                    Container(
                      margin: EdgeInsets.only(left: ResponsiveDim.width10, right: ResponsiveDim.width10),
                      child: Text(
                        widget.description??'',
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'poppins',
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(height: ResponsiveDim.height15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BigText(text: "Producer :",size: ResponsiveDim.font24,),
                        SizedBox(width: ResponsiveDim.width10),
                        Expanded(child: BigText(text: widget.producer??'', color: Colors.blue,)),

                      ],
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

  Widget _buildPageItem(int idx) {
    Matrix4 matrix = Matrix4.identity();
    if (idx == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - idx) * (1 - _scaleFactor);
      var currTransformation = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTransformation, 0);
    } else if (idx == _currPageValue.floor() + 1) {
      var currScale = _scaleFactor + (_currPageValue - idx + 1) * (1 - _scaleFactor);
      var currTransformation = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTransformation, 0);
    } else if (idx == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - idx) * (1 - _scaleFactor);
      var currTransformation = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTransformation, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 0);
    }

    return Transform(
      transform: matrix,
      child: Container(
        height: ResponsiveDim.pageViewContainer,
        margin: EdgeInsets.only(left: ResponsiveDim.width10, right: ResponsiveDim.width10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveDim.radius15),
          color: idx.isEven ? const Color(0xFF69c5df) : const Color(0xFF9294cc),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: MemoryImage(widget.imageBytesList![idx]),
          ),
        ),
      ),
    );
  }
}

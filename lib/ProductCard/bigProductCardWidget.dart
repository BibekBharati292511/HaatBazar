import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Utilities/iconButtonWithText.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';
import 'package:hatbazarsample/Widgets/smallText.dart';

class ProductCardBigWidget extends StatefulWidget {
  final String productName;
  final String description;
  final String price;
  final double rating;
  final int reviewCount;
  final String producer;
  final String imagePath;

  const ProductCardBigWidget({
    Key? key,
    required this.productName,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.producer,
    required this.imagePath,
  }) : super(key: key);

  @override
  _ProductCardBigWidgetState createState() => _ProductCardBigWidgetState();
}

class _ProductCardBigWidgetState extends State<ProductCardBigWidget> {
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
    return Container(
      padding: EdgeInsets.only(bottom:ResponsiveDim.height10),
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
            color: AppColors.backgroundColor,
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
                itemCount: 5,
                itemBuilder: (context, position) {
                  return _buildPageItem(position);
                },
              ),
            ),
          ),
          DotsIndicator(
            dotsCount: 5,
            position: _currPageValue,
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
                      BigText(text: widget.productName),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: ResponsiveDim.width10, right: ResponsiveDim.width10),
                    child: SmallText(
                      text: widget.description,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: ResponsiveDim.height15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BigText(text: widget.price, color: Colors.red, size: ResponsiveDim.bigFont),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BigText(text: "Producer :",size: ResponsiveDim.font24,),
                      SizedBox(width: ResponsiveDim.width10),
                      Expanded(child: BigText(text: widget.producer, color: Colors.blue,)),
                    ],
                  ),
                  SizedBox(height: ResponsiveDim.height15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButtonWithText(
                        width: ((ResponsiveDim.screenWidth) / 2) - ResponsiveDim.width20,
                        buttonText: BigText(
                          text: "Chat now ",
                          color: Colors.blue[800],
                          weight: FontWeight.bold,
                          size: ResponsiveDim.height20,
                        ),
                        iconColor: Colors.blue,
                        icon: Icons.messenger,
                        borderRadius: ResponsiveDim.radius15,
                        backgroundColor: Colors.white,
                        onPressed: () {},
                      ),
                      SizedBox(width: ResponsiveDim.width10),
                      IconButtonWithText(
                        width: ((ResponsiveDim.screenWidth) / 2),
                        buttonText: BigText(
                          text: "Add to cart ",
                          color: Colors.white,
                          weight: FontWeight.bold,
                          size: ResponsiveDim.height20,
                        ),
                        borderRadius: ResponsiveDim.radius15,
                        iconColor: Colors.white,
                        icon: Icons.add_shopping_cart,
                        onPressed: () {
                          // Your button click logic here
                          //  print('Button clicked!');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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
            image: AssetImage(widget.imagePath),
          ),
        ),
      ),
    );
  }
}

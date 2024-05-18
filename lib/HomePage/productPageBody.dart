import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/ProductCard/product.dart';
import 'package:hatbazarsample/Services/get_all_category.dart';
import 'package:hatbazarsample/Services/get_all_product.dart';
import 'package:hatbazarsample/Services/sub_category_service.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';
import 'package:hatbazarsample/Widgets/icon_and_text.dart';
import 'package:hatbazarsample/Widgets/smallText.dart';

import '../Model/CategoryService.dart';
import '../Services/category_service.dart';
import '../Utilities/iconButtonWithText.dart';
import '../main.dart';
List<List<Product>> selectedProductList = [];

class ProductPageBody extends StatefulWidget {
  const ProductPageBody({super.key});

  @override
  State<ProductPageBody> createState() => _ProductPageBodyState();
}

class _ProductPageBodyState extends State<ProductPageBody> {
  final CategoryServices _categoryService = CategoryServices(); // Initialize CategoryService
  late Future<List<Categorys>> _categories; // Future for storing categories
  final SubCategoryService _subCategoryService=SubCategoryService();
  late Future<List<SubCategory>> _subCategories;
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currPageValue = 0.0;
  final double _scaleFactor = 0.8;
  final double _height = ResponsiveDim.pageViewContainer;
  int selectedIndex = 0;




  @override
  void initState() {
    super.initState();
    _categories = _categoryService.getAllCategories();
    _subCategories=_subCategoryService.getAllSubCategories();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
       // _categories = _categoryService.getAllCategories();
       // fetchAllProduct();
        // print("curr value is "+_currPageValue.toString());
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
    print(productLists[0]);
    switch (selectedIndex) {
      case 0:
        print("case 0");
        selectedProductList = productLists; // All products
        break;
      case 1:
        print("case 1");
        selectedProductList = recommendedProductLists;
        print(selectedProductList);// Recommended products
        break;
      case 2:
        print("case 2");
        selectedProductList = freeDeliveryProductLists; // Free delivery products
        break;
      case 3:
        print("case 3");
        selectedProductList = nearMeProductLists; // Products near me
        break;
      default:
        print("case ddefault");
        selectedProductList = productLists; // Default to all products
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          //slider
          Container(
            color: AppColors.backgroundColor,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: ResponsiveDim.width20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: BigText(text: "Featured Products"),
                  ),
                ),
                SizedBox(height: ResponsiveDim.height10),
                SizedBox(
                  height: ResponsiveDim.pageView,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: featuredProducts.length,
                    itemBuilder: (context, position) {
                      return _buildPageItem(position, featuredProducts[position]);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ResponsiveDim.height10),
          //dots
          DotsIndicator(
            dotsCount: featuredProducts.length,
            position: _currPageValue.round(),
            decorator: const DotsDecorator(
              color: Colors.black87, // Inactive color
              activeColor: Colors.redAccent,
            ),
          ),
          //Categories based;
          SizedBox(height: ResponsiveDim.height10),
          SizedBox(height: ResponsiveDim.height10),
          Container(
            color: AppColors.backgroundColor,
            padding: EdgeInsets.symmetric(horizontal: ResponsiveDim.width20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BigText(
                      text: "Categories",
                    ),
                    SmallText(
                      text: "All you need is here ",
                    ),
                    SizedBox(height: 5,),
                  ],
                ),
                IconButtonWithText(
                  width: ResponsiveDim.width150,
                  height: ResponsiveDim.height45,
                  buttonText: BigText(
                    text: "show more",
                    size: ResponsiveDim.height15,
                  ),
                  icon: Icons.arrow_forward,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    // Your button click logic here
                    // print('Button clicked!');
                  },
                ),
              ],
            ),
          ),
          Container(
            width: ResponsiveDim.screenWidth,
            height: 5,
            color: AppColors.backgroundColor,
          ),
          FutureBuilder<List<Categorys>>(
            future: _categories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // or any loading widget
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final categoriesList = snapshot.data;
                return Container(
                  color: AppColors.backgroundColor,
                 // padding: EdgeInsets.only(top: ResponsiveDim.height10),
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: categoriesList?.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        final category = categoriesList?[index];
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(ResponsiveDim.radius15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: ResponsiveDim.screenHeight / 7.4190,
                                height: ResponsiveDim.screenHeight / 7.4190,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(ResponsiveDim.radius15),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(ResponsiveDim.radius15),
                                  child: Image.network(
                                    category!.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              SizedBox(height: ResponsiveDim.screenHeight / 445.142),
                              BigText(
                                text: category!.categoryName,
                                size: ResponsiveDim.height20,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),
          FutureBuilder<List<SubCategory>>(
            future: _subCategories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // or any loading widget
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final categoriesList = snapshot.data;
                return Container(
                  color: AppColors.backgroundColor,
                  // padding: EdgeInsets.only(top: ResponsiveDim.height10),
                  child: SizedBox(
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: categoriesList?.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        final category = categoriesList?[index];
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(ResponsiveDim.radius15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: ResponsiveDim.screenHeight / 7.4190,
                                height: ResponsiveDim.screenHeight / 7.4190,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(ResponsiveDim.radius15),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(ResponsiveDim.radius15),
                                  child: Image.network(
                                    category!.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              SizedBox(height: ResponsiveDim.screenHeight / 445.142),
                              BigText(
                                text: category!.categoryName,
                                size: ResponsiveDim.height20,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),






          //slogan text
          Container(
            padding: EdgeInsets.only(
                top: ResponsiveDim.height10, bottom: ResponsiveDim.height10),
      
            child: SmallText(
              text: "One small step for agro digitalization",
              color: Colors.blue,
            ),
            //padding: EdgeInsets.only(top:responsiveDim.height45),
          ),
          //SizedBox(height:responsiveDim.height20),
          //For you text
          Container(
            color: AppColors.backgroundColor,
            //  margin: EdgeInsets.only(top:responsiveDim.height45,bottom:responsiveDim.height15),
            padding: EdgeInsets.only(
                left: ResponsiveDim.width20, right: ResponsiveDim.width20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    BigText(
                      text: "For you",
                    ),
                    SmallText(
                      text: "Shop with thrill ",
                    ),
                  ],
                ),
              ],
            ),
          ),
      
          //slider for different for you sections.
          Container(
            color: AppColors.backgroundColor,
            padding: EdgeInsets.only(
                left: ResponsiveDim.width20, top: ResponsiveDim.height10),
            child: Column(
              children: [
                SizedBox(
                  height: 105,
                  width: ResponsiveDim.screenWidth,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      List<String> forYou = [
                        "All",
                        "Recommended",
                        "Free Delivery",
                        "Near me"
                      ];
                      //int selectedIndex = 0;
                      bool isSelected = index ==
                          selectedIndex; // Check if the current item is selected
      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex =
                                ((selectedIndex + 1) % productLists.length) ;
                            //print("selected index "+index.toString());
                            selectedIndex = index;
                            print("selected index "+selectedIndex.toString());// Update the selected index
                          });
                          // Handle the click event for each category
                          //print("Clicked on: ${forYou[index]}");
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: ResponsiveDim.radius6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: ResponsiveDim.screenHeight / 8,
                                height: ResponsiveDim.screenHeight / 9,
                                decoration: BoxDecoration(
                                  //border: BorderColor,
                                  border: Border.all(
                                      color: isSelected
                                          ? Colors.red
                                          : Colors.white70),
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(
                                      ResponsiveDim.radius15),
                                  image: DecorationImage(
                                    fit: BoxFit.scaleDown,
                                    image: AssetImage(
                                        "assets/images/icons/${forYou[index].toLowerCase()}.png"),
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: BigText(
                                    text: forYou[index],
                                    size: ResponsiveDim.height15,
                                    color: isSelected ? Colors.red : Colors.black,
                                  ),
                                ),
                              ),

                              SizedBox(
                                  height: ResponsiveDim.screenHeight / 445.142),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      
          // Container(
          //   padding: EdgeInsets.only(left: responsiveDim.height30),
          //   color: Color(0xB7F6F3C1),
          //   child: ProductWidget(
          //     products: [
          //       Product(name: 'Potato', imagePath: 'assets/images/productImage/potato.png', rating: 4.5, price: '50'),
          //       Product(name: 'Mango', imagePath: 'assets/images/productImage/mango.png', rating: 3.8, price: '30'),
          //       Product(name: "Orange", imagePath: "assets/images/orange.png", rating: 4, price: "35"),
          //       Product(name: "Tomato", imagePath: 'assets/images/productImage/tomato.png', rating: 2.1, price: '40.3'),
          //       Product(name: 'Potato', imagePath: 'assets/images/productImage/potato.png', rating: 4.5, price: '50'),
          //       Product(name: 'Mango', imagePath: 'assets/images/productImage/mango.png', rating: 3.8, price: '30'),
          //       Product(name: "Orange", imagePath: "assets/images/orange.png", rating: 4, price: "35"),
          //       Product(name: "Tomato", imagePath: 'assets/images/productImage/tomato.png', rating: 2.1, price: '40.3'),
          //
          //     ],
          //   ),
          // ),
          if (selectedIndex != -1)
            Container(
              color: AppColors.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 10),
                child: Column(
                  children: [
                    // Check if selectedProductList is empty
                    if (selectedProductList.isEmpty)
                      Text("No data available at the moment. Please try again later")
                    else
                      for (int i = 0; i < selectedProductList.length; i ++)
                        Column(
                          children: [
                            ProductWidget(products: selectedProductList[i]),
      
                            SizedBox(height: ResponsiveDim.height15),
                          ],
                        ),
                    SizedBox(height: ResponsiveDim.height15),
                  ],
                ),
              ),
            ),
      
      
          Container(
              color:AppColors.backgroundColor,
            height: ResponsiveDim.height45,
          ),
        ],
      ),
    );
  }
  List<FeaturedProductModel> featuredProducts = [
    FeaturedProductModel(
      name: 'Cucumber',
      image: 'assets/images/cucumber.png',
      rating: 4.5,
      reviews: 6,
      status: 'Normal',
      distance: '5.3 Km',
      time: '1 hour',
    ),
    FeaturedProductModel(
      name: 'Orange',
      image: 'assets/images/orange.png',
      rating: 3,
      reviews: 4,
      status: 'Normal',
      distance: '1.2 Km',
      time: '40 min',
    ),
    FeaturedProductModel(
      name: 'Tomato',
      image: 'assets/images/tomato.png',
      rating: 4,
      reviews: 7,
      status: 'Normal',
      distance: '0.8 Km',
      time: '30 min',
    ),
    FeaturedProductModel(
      name: 'Potato',
      image: 'assets/images/potato.png',
      rating: 4.2,
      reviews: 5,
      status: 'Normal',
      distance: '1 Km',
      time: '35 min',
    ),
  ];

  Widget _buildPageItem(int idx, FeaturedProductModel product) {
    Matrix4 matrix = Matrix4.identity();
    if (idx == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - idx) * (1 - _scaleFactor);
      var currTransformation = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTransformation, 0);
    } else if (idx == _currPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currPageValue - idx + 1) * (1 - _scaleFactor);
      var currTransformation = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTransformation, 0);
    } else if (idx == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - idx) * (1 - _scaleFactor);
      var currTransformation = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTransformation, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 0);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          Container(
            height: ResponsiveDim.pageViewContainer,
            margin: EdgeInsets.only(
                left: ResponsiveDim.width10, right: ResponsiveDim.width10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ResponsiveDim.radius30),
              color: idx.isEven
                  ? const Color(0xFF69c5df)
                  : const Color(0xFF9294cc),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(product.image),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: ResponsiveDim.pageViewTextContainer,
              margin: EdgeInsets.only(
                  left: ResponsiveDim.width30,
                  right: ResponsiveDim.width30,
                  bottom: ResponsiveDim.height5
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveDim.radius30),
                  color: AppColors.productCardBgColor,
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0xFFe8e8e8),
                        blurRadius: 5.0,
                        offset: Offset(5, 5)),
                    BoxShadow(
                      color: AppColors.productCardBgColor,
                      offset: Offset(-5, 0),
                    ),
                    BoxShadow(
                      color: AppColors.productCardBgColor,
                      offset: Offset(5, 0),
                    ),
                  ]),
              child: Container(
                padding: EdgeInsets.only(
                    top: ResponsiveDim.height15,
                    left: ResponsiveDim.height15,
                    right: ResponsiveDim.height15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BigText(text: product.name),
                    SizedBox(
                      height: ResponsiveDim.height10,
                    ),
                    Row(
                      children: [
                        Wrap(
                          children: List.generate(
                              5,
                                  (index) => Icon(
                                Icons.star,
                                color: Colors.cyan,
                                size: ResponsiveDim.height15,
                              )),
                        ),
                        SizedBox(
                          width: ResponsiveDim.width10,
                        ),
                        SmallText(text: product.rating.toString()),
                        SizedBox(
                          width: ResponsiveDim.width10,
                        ),
                        SmallText(text: "${product.reviews} Reviews"),
                      ],
                    ),
                    SizedBox(
                      height: ResponsiveDim.height20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconAndWidget(
                          icon: Icons.circle_sharp,
                          text: product.status,
                          iconColor: AppColors.primaryColor,
                        ),
                        IconAndWidget(
                            icon: Icons.location_on,
                            text: product.distance,
                            iconColor: AppColors.primaryColor),
                        IconAndWidget(
                            icon: Icons.access_time_rounded,
                            text: product.time,
                            iconColor: AppColors.redColor)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
class FeaturedProductModel {
  final String name;
  final String image;
  final double rating;
  final int reviews;
  final String status;
  final String distance;
  final String time;

  FeaturedProductModel({
    required this.name,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.status,
    required this.distance,
    required this.time,
  });
}


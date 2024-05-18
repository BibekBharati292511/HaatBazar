import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hatbazarsample/HomePage/main_drawer.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';
import 'package:hatbazarsample/Widgets/smallText.dart';

import '../AddToCart/cart_controller.dart';
import '../Filter_And_Search/search_screen_delegate.dart';
import '../Services/get_all_product.dart';
import 'bottom_navigation.dart';

class MainProductPage extends StatefulWidget {
  const MainProductPage({super.key});

  @override
  State<MainProductPage> createState() => _MainProductPageState();
}

class _MainProductPageState extends State<MainProductPage> {
  late List<ProductDto> allProducts;
  final CartController cartController = Get.find();

  @override
  void initState() {
    super.initState();
    _fetchAllProducts();
  }
  Future<void> _fetchAllProducts() async {
    allProducts = await fetchAllProduct(); // Fetch all products
  }
  void _openSearch() {
    showSearch(
      context: context,
      delegate: ProductSearchDelegate(
        allProducts: allProducts, // Pass product data to search delegate
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
   // Get.put(CartController());
    print("height: ${MediaQuery.of(context).size.width}");

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 5,
            color:AppColors.backgroundColor,
          ),
          //header
          AppBar(
            backgroundColor: AppColors.backgroundColor,
            elevation: 0,
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: ResponsiveDim.radius6),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BigText(
                          text: "Nepal",
                          color: AppColors.primaryColor,
                        ),
                        SmallText(
                          text: "Bhaktapur",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              Obx(() => Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart,size: 35,),
                    onPressed: () {
                      Navigator.pushNamed(context, 'toCart');
                    },
                  ),
                  if (cartController.cartItemCount.value > 0)
                    Positioned(
                      right: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          cartController.cartItemCount.value.toString(),
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              )),
              SizedBox(width: 5,),
              GestureDetector(
                onTap: (){
                  _openSearch();
                },
                child: Container(
                  width: ResponsiveDim.height35,
                  height: ResponsiveDim.height35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveDim.radius15),
                    color: AppColors.primaryColor,
                  ),
                  margin: EdgeInsets.only(right: ResponsiveDim.width20),
                  child: Icon(
                    Icons.search,
                    color: AppColors.staticIconColor,
                    size: ResponsiveDim.icon24,
                  ),
                ),
              ),
            ],
            iconTheme: IconThemeData(
              size: ResponsiveDim.height45,
              color: AppColors.primaryButtonColor,
            ),
          ),

          Container(
            height: 5,
            color: AppColors.backgroundColor,
          ),
          //body
          // const Expanded(child:SingleChildScrollView(
          //   child:ProductPageBody()
          // )),

          //const BottomWidget(),
          const Expanded(
            child: Center(
              child: BottomWidget(),
            ),
          ),
        ],
      ),
      drawer:const Drawer(
          child:MainDrawer()
      ),
    );
  }
}

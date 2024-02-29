import 'package:flutter/material.dart';
import 'package:hatbazarsample/HomePage/main_drawer.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';
import 'package:hatbazarsample/Widgets/smallText.dart';

import 'bottom_navigation.dart';

class MainProductPage extends StatefulWidget {
  const MainProductPage({super.key});

  @override
  State<MainProductPage> createState() => _MainProductPageState();
}

class _MainProductPageState extends State<MainProductPage> {
  @override
  Widget build(BuildContext context) {
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
              Container(
                margin: EdgeInsets.only(right: ResponsiveDim.width10),
                child: Icon(
                  Icons.shopping_cart,
                  color: AppColors.primaryButtonColor,
                  size: ResponsiveDim.icon44,
                ),
              ),
              Container(
                width: ResponsiveDim.width45,
                height: ResponsiveDim.height45,
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
            child: BottomWidget(),
          ),
        ],
      ),
      drawer:const Drawer(
          child:MainDrawer()
      ),
    );
  }
}

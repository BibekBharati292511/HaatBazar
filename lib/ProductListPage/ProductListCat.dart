import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hatbazarsample/ProductCard/bigProductCardWidget.dart';

import '../AddToCart/cart_controller.dart';

import '../Filter_And_Search/productFilterPage.dart';
import '../Filter_And_Search/search_screen_delegate.dart';
import '../Model/UserData.dart';
import '../Services/get_all_product.dart';
import '../Services/get_imageBy_product_name.dart'; // Assuming this service fetches store data
import '../Utilities/ResponsiveDim.dart';
import '../Utilities/colors.dart';
import '../Widgets/smallText.dart';
import '../main.dart';

class ProductListCat extends StatefulWidget {
  const ProductListCat({super.key});

  @override
  _ProductListCatState createState() => _ProductListCatState();
}

class _ProductListCatState extends State<ProductListCat> {
  final CartController cartController = Get.find(); // Get the CartController instance
  late List<ProductDto> allProducts;
  late String producerName;
  late List<dynamic> storeDatas;
  List<ProductDto> _products = [];
  Map<String, List<Uint8List>> _productImages = {}; // Maps product names to image lists
  Map<int, List<dynamic>> _storeDataMap = {}; // Maps store IDs to store data

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Fetch products upon initialization
    _fetchAllProducts();
  }
  List<ProductDto> _filteredProducts = []; // Store filtered products

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
  void _openFilterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFilterPage(
          onFilterApplied: (filteredProducts) {
            setState(() {
              _filteredProducts = filteredProducts; // Update the product list
            });
          },
        ),
      ),
    );
  }

  Map<int, String> _storeProducerMap = {};

  Future<void> _fetchProducts() async {
    try {
      List<ProductDto> products = await fetchAllProduct();
      _products = products;

      for (ProductDto product in products) {
        int storeId = product.storeId;

        if (!_storeDataMap.containsKey(storeId)) {
          var storeDataJson = await UserDataService.fetchStoreDataById(storeId);
          var storeData = jsonDecode(storeDataJson);

          if (storeData is List<dynamic>) {
            _storeDataMap[storeId] = storeData;
          } else {
            print("Unexpected data format: Expected a list");
            return;
          }
        }

        // Assign producer name to the correct store ID
        var storeData = _storeDataMap[storeId];
        if (storeData != null && storeData.isNotEmpty) {
          var firstItem = storeData[0];
          String producerName = firstItem.containsKey("name") ? firstItem["name"] : "Unknown Producer";

          _storeProducerMap[storeId] = producerName; // Store the producer name with the store ID
        }

        List<String> images = await ImageFetcherService.fetchProductImages(product.name);
        List<Uint8List> imageBytes = [];

        for (String base64Image in images) {
          imageBytes.add(_decodeBase64ToUint8List(base64Image));
        }

        _productImages[product.name] = imageBytes;
      }

      setState(() {}); // Refresh UI with new data
    } catch (e) {
      print("Error fetching products, store data, or images: $e");
    }
  }

  Uint8List _decodeBase64ToUint8List(String base64String) {
    String base64Data = base64String.split(',').last; // Removes prefix if needed
    return base64.decode(base64Data);
  }

  @override
  Widget build(BuildContext context) {
    print("filtered value is $filtered");
    return Scaffold(
      body: Container(
        color: AppColors.backgroundColor,
        padding: EdgeInsets.only(top: ResponsiveDim.height45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            !filtered?
            _buildProductList():_buildFilteredProductList(),
            SizedBox(height: ResponsiveDim.height5 ,),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              filtered=false;
              Navigator.pushNamed(context, 'homePage');
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 0),
            child: GestureDetector(
              onTap: () {
                print("Tapped");
                _openSearch();
              },
              child: Container(
                padding: EdgeInsets.only(left: ResponsiveDim.radius6),
                alignment: Alignment.centerLeft,
                height: ResponsiveDim.icon44,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: SmallText(
                        text: "Daily Consumable Items",
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
          ),
          Row(
            children: [
              Obx(() => Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
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
              SizedBox(width: ResponsiveDim.width10,),
              GestureDetector(
                onTap: (){
                  print("pressed");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductFilterPage(
                        onFilterApplied: (filteredProducts) {
                          setState(() {
                            _filteredProducts = filteredProducts;// Update the product list
                            print("filtered product here");
                            print(_filteredProducts);
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Icon(
                  Icons.filter_alt_rounded,
                  color: AppColors.primaryButtonColor,
                  size: ResponsiveDim.height30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    print("running build produt");
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: _products.map((product) {
            print("Creating ProductCardBigWidget - producer: ${product.storeId}, Product Name: ${product.name}");
            int storeId = product.storeId;
            List<Uint8List> images = _productImages[product.name] ?? [];
            print(_storeProducerMap);
            String producerName = _storeProducerMap[storeId] ?? "Unknown Producer";
            return ProductCardBigWidget(
              storeId: storeId,
              productName: product.name,
              description: product.description,
              price: 'Rs. ${product.price} /Kg',
              rating: 4.5,
              reviewCount: 35,
              producer: producerName,
              imageBytesList: images,
            );
          }).toList(),
        ),
      ),
    );
  }
  Widget _buildFilteredProductList() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: _filteredProducts.map((product) {
            print("Creating ProductCardBigWidsssssssssssdget - Store ID: ${product.storeId}, Product Name: ${product.name}");

            int storeId = product.storeId;
            List<Uint8List> images = _productImages[product.name] ?? [];

            // Retrieve producer name based on store ID from a pre-populated map
            String producerName = _storeProducerMap[storeId] ?? "Unknown Producer";

            return ProductCardBigWidget(
              storeId: storeId,
              productName: product.name,
              description: product.description,
              price: 'Rs. ${product.price} /Kg',
              rating: 4.5,
              reviewCount: 35,
              producer: producerName,
              imageBytesList: images,
            );
          }).toList(),
        ),
      ),
    );
  }


}

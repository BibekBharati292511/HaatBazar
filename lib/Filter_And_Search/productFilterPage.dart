import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/Filter_And_Search/product_filter_model.dart';
import 'package:hatbazarsample/ProductListPage/ProductListCat.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';

import '../Model/CategoryService.dart';
import '../Services/get_all_product.dart';
import '../main.dart';
import 'filter_product.dart';

class ProductFilterPage extends StatefulWidget {
  final Function(List<ProductDto>) onFilterApplied; // Callback to return filtered products

  ProductFilterPage({required this.onFilterApplied});

  @override
  _ProductFilterPageState createState() => _ProductFilterPageState();
}

class _ProductFilterPageState extends State<ProductFilterPage> {
  String? selectedCategoryName;
  String? selectedSubcategoryName;
  final ProductFilterService productFilterService = ProductFilterService(); // Initialize the service
  late ProductFilterOptions _filterOptions; // Local filter options for this page
  List<ProductDto> _filteredProducts = []; // Store filtered products

  @override
  void initState() {
    super.initState();
    _filterOptions = ProductFilterOptions(); // Initialize filter options
  }
  bool _isValidPriceRange(double? minPrice, double? maxPrice) {
    if (minPrice == null || maxPrice == null) {
      return false;
    }
    return minPrice <= maxPrice;
  }

  bool _isValidQuantityRange(double? minQty, double? maxQty) {
    if (minQty == null || maxQty == null) {
      return false;
    }
    return minQty <= maxQty;
  }

  // Future<void> _applyFilter() async {
  //   // Fetch all products initially
  //   await productFilterService.fetchAllProducts();
  //   filtered=true;
  //
  //   // Apply each filter condition
  //   if (_filterOptions.minPrice != null && _filterOptions.maxPrice != null) {
  //     await productFilterService.fetchProductsByPriceRange(
  //       _filterOptions.minPrice!,
  //       _filterOptions.maxPrice!,
  //     );
  //   }
  //
  //   if (_filterOptions.category != null) {
  //     await productFilterService.fetchProductsByCategoryId(
  //       int.parse(_filterOptions.category!),
  //     );
  //   }
  //
  //   if (_filterOptions.subCategory != null) {
  //     await productFilterService.fetchProductsBySubCategoryId(
  //       int.parse(_filterOptions.subCategory!),
  //     );
  //   }
  //
  //   if (_filterOptions.harvestedSeason != null) {
  //     await productFilterService.fetchProductsByHarvestedSeason(
  //       _filterOptions.harvestedSeason!,
  //     );
  //   }
  //
  //   if (_filterOptions.minQty != null && _filterOptions.maxQty != null) {
  //     await productFilterService.fetchProductsByAvailableQtyRange(
  //       _filterOptions.minQty!,
  //       _filterOptions.maxQty!,
  //     );
  //   }
  //   if (_filterOptions.minPrice == null &&
  //       _filterOptions.maxPrice == null &&
  //       _filterOptions.category == null &&
  //       _filterOptions.subCategory == null &&
  //       _filterOptions.harvestedSeason == null &&
  //       _filterOptions.minQty == null &&
  //       _filterOptions.maxQty == null) {
  //     // No filters applied, show dialog and return early
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text("No Filters Applied"),
  //           content: Text("Please set at least one filter."),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context); // Close the dialog
  //               },
  //               child: Text("OK"),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //     return; // Exit the function early
  //   }
  //
  //   // Final filtered products
  //   _filteredProducts = productFilterService.filteredProducts;
  //
  //   // Return filtered products to the caller
  //   widget.onFilterApplied(_filteredProducts);
  //
  //   print("Filtered applied");
  //   print("Filtered product is $_filteredProducts");
  //   print("Filtered option is $_filterOptions");
  //
  //   Navigator.pop(context); // Go back to the product list
  // }
  Future<void> _applyFilter() async {
    // Check if any filter options are set
    if (_filterOptions.minPrice == null &&
        _filterOptions.maxPrice == null &&
        categoryID == null &&
        subCategoryID == null &&
        _filterOptions.harvestedSeason == null &&
        _filterOptions.minQty == null &&
        _filterOptions.maxQty == null) {
      _showNoFilterDialog();
      return;
    }
    if(_filterOptions.minPrice !=null && _filterOptions.maxPrice!=null) {
      // Validate the price range
      if (!_isValidPriceRange(
          _filterOptions.minPrice, _filterOptions.maxPrice)) {
        _showInvalidInputDialog("Invalid Price Range",
            "The minimum price must be less than or equal to the maximum price.");
        return;
      }
    }
    if(_filterOptions.minQty !=null && _filterOptions.maxQty!=null) {
      // Validate the quantity range
      if (!_isValidQuantityRange(
          _filterOptions.minQty, _filterOptions.maxQty)) {
        _showInvalidInputDialog("Invalid Quantity Range",
            "The minimum quantity must be less than or equal to the maximum quantity.");
        return;
      }
    }

    // Fetch all products initially
    await productFilterService.fetchAllProducts();

    // Apply the filter conditions
    if (_filterOptions.minPrice != null && _filterOptions.maxPrice != null) {
      await productFilterService.fetchProductsByPriceRange(
        _filterOptions.minPrice!,
        _filterOptions.maxPrice!,
      );
    }
    filtered=true;

    if (categoryID != null ) {
      _filterOptions.category = categoryID.toString(); // Ensure category is set
      await productFilterService.fetchProductsByCategoryId(categoryID!
      );

    }

    if (subCategoryID != null ) {
      _filterOptions.subCategory = subCategoryID.toString(); // Ensure subcategory is set
      await productFilterService.fetchProductsBySubCategoryId(subCategoryID!);
    }

    if (_filterOptions.harvestedSeason != null) {
      await productFilterService.fetchProductsByHarvestedSeason(
        _filterOptions.harvestedSeason!,
      );
    }

    if (_filterOptions.minQty != null && _filterOptions.maxQty != null) {
      await productFilterService.fetchProductsByAvailableQtyRange(
        _filterOptions.minQty!,
        _filterOptions.maxQty!,
      );
    }

    // Final filtered products
    _filteredProducts = productFilterService.filteredProducts;

    if (_filteredProducts.isEmpty) {
      _showNoResultsDialog(); // No products matched the filters
      return;
    }

    // If everything is fine, apply the filtered products
    widget.onFilterApplied(_filteredProducts);

    Navigator.pop(context); // Go back to the product list
  }

  void _showNoFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("No Filters Applied"),
          content: Text("Please set at least one filter."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showInvalidInputDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showNoResultsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("No Products Found"),
          content: Text("No products match the applied filters."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
  Future<void> _showCategoryDialog() async {
    List<Category> categories = await CategoryService.fetchCategories();
    Category? selectedCategory;
    Category? selectedSubcategory;
    Map<int, List<Category>> cachedSubcategories = {};
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Choose Category'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category:'),
                  Column(
                    children: categories.map((category) {
                      return RadioListTile<Category>(
                        title: Text(category.categoryName),
                        value: category,
                        groupValue: selectedCategory,
                        onChanged: (Category? newValue) async {
                          setState(() {
                            selectedCategory = newValue;
                            // Reset selectedSubcategory when category changes
                            selectedSubcategory = null;
                          });

                          // Fetch subcategories only if not already cached
                          if (!cachedSubcategories.containsKey(newValue!.id)) {
                            List<Category> subcategories = await CategoryService.fetchSubcategories(newValue.id);
                            cachedSubcategories[newValue.id] = subcategories;
                            setState(() {
                              selectedSubcategory = null;
                            });
                          } else {
                            setState(() {
                              selectedSubcategory = null;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Text('Subcategory:'),
                  selectedCategory != null && cachedSubcategories.containsKey(selectedCategory?.id)
                      ? Column(
                    children: cachedSubcategories[selectedCategory?.id]!.map((subcategory) {
                      return RadioListTile<Category>(
                        title: Text(subcategory.categoryName),
                        value: subcategory,
                        groupValue: selectedSubcategory,
                        onChanged: (Category? newValue) {
                          setState(() {
                            selectedSubcategory = newValue;
                          });
                        },
                      );
                    }).toList(),
                  )
                      : SizedBox(),
                ],
              ),
              actions: <Widget>[
                CustomButton(
                  buttonText: 'Save',
                  onPressed: (){
                    setState(() {
                      selectedCategoryName = selectedCategory?.categoryName;
                      selectedSubcategoryName = selectedSubcategory?.categoryName;
                    });
                    categoryID=selectedCategory?.id;
                    subCategoryID=selectedSubcategory?.id;
                    print('Selected Category ID: ${selectedCategory?.id}');
                    print('Selected Subcategory ID: ${selectedSubcategory?.id}');
                    Navigator.of(context).pop();
                  },
                ),


              ],
            );
          },
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Filters"),
        actions: [
          IconButton(
            icon: Icon(Icons.check), // Apply the filter
            onPressed:(){
              _applyFilter();
            }
             // Apply filters and return results
          ),
        ],
      ),
      body: _buildFilterContent(),
    );
  }

  Widget _buildFilterContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grouped card for price range
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Price Range", style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: "Min Price"),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            _filterOptions.minPrice = double.tryParse(value);
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: "Max Price"),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            _filterOptions.maxPrice = double.tryParse(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16), // Add some space

          // Grouped card for harvested season
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Harvested Season", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    decoration: InputDecoration(labelText: "Harvested Season"),
                    onChanged: (value) {
                      _filterOptions.harvestedSeason = value;
                    },
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16), // Add some space

          // Grouped card for available quantity
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Available Quantity Range", style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: "Min Quantity"),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            _filterOptions.minQty = double.tryParse(value);
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: "Max Quantity"),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            _filterOptions.maxQty = double.tryParse(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16), // Add some space
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("Filter By Category", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,overflow: TextOverflow.ellipsis)),
                    SizedBox(width: ResponsiveDim.width5,),
                    Text(
                      "(${selectedCategoryName ?? 'category'} - ${selectedSubcategoryName ?? 'subcategory'})",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ResponsiveDim.height15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: (){
                    _showCategoryDialog();
                  },
                    child: const Icon(Icons.edit,color: Colors.red,))
              ],
            ),
          ),

          SizedBox(height: 16), // Add some space

          // Apply and clear filters buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                  width: ResponsiveDim.screenWidth/2.4,
                  height: 50,
                  buttonText: "Apply",
                  onPressed: (){
                    print(categoryID);
                    print(subCategoryID);
                _applyFilter();
              }
              ),
              CustomButton(
                width: ResponsiveDim.screenWidth/2.5,
                height: 50,
                buttonText: "Clear ", onPressed: (){
                _clearFilter();
              },
              color: Colors.red,),
            ],
          ),

        ],
      ),
    );
  }

  void _clearFilter() {
    categoryID=null;
    subCategoryID=null;
    _filterOptions = ProductFilterOptions();
    filtered = false; // Set filtered to false
    Navigator.push(context,  MaterialPageRoute(
        builder: (context) => ProductListCat()));
  }

}

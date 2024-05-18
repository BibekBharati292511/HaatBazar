import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:hatbazarsample/Model/fire_base_storage_service.dart';
import 'package:hatbazarsample/main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';
import 'package:hatbazarsample/Widgets/smallText.dart';
import 'package:hatbazarsample/Widgets/progress_indicator.dart';

import '../../../Model/CategoryService.dart';
import '../../../Services/image_uploader_service.dart';
import '../../../Widgets/image_to_fire_base.dart';
import '../../../main.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  //List<File> _imageFiles = [];
  final TextEditingController _productNameEnglishController = TextEditingController();
  final TextEditingController _productNameNepaliController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _subCategoryController = TextEditingController();
  String? selectedCategoryName;
  String? selectedSubcategoryName;
  bool isContinueButtonEnabled = false;
  void _updateContinueButtonState() {
    setState(() {
      isContinueButtonEnabled = _productNameEnglishController.text.isNotEmpty &&
          _productNameNepaliController.text.isNotEmpty &&
          selectedCategoryName != null &&
          selectedSubcategoryName != null &&
          imageFiles.isNotEmpty;
    });
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    List<XFile>? pickedImages = await picker.pickMultiImage(
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 90,
    );
    if (pickedImages != null) {
      int remainingSlots = 5 - imageFiles.length;
      if (remainingSlots > 0) {
        setState(() {
          List<File> newFiles = pickedImages
              .sublist(0, min(pickedImages.length, remainingSlots))
              .map((pickedImage) => File(pickedImage.path))
              .toList();

          // Convert images to bytes and store in a list
          for (File file in newFiles) {
            Uint8List imageBytes = file.readAsBytesSync(); // Reads the file as bytes
            imageBytesList.add(imageBytes);
          }
          // Add the files to imageFiles list
          imageFiles.addAll(newFiles);
        });
        _updateContinueButtonState();
      }
    }
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
                    _updateContinueButtonState();
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
      body: Container(
        color: AppColors.backgroundColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveDim.width15),
          child: Column(
            children: [
              AppBar(
                backgroundColor: AppColors.backgroundColor,
                title: Text('Add product'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProgressIndicators(
                        currentPage: 1,
                        totalPages: 3,
                        pageName: 'Basic info',
                      ),
                      SizedBox(height: ResponsiveDim.height10,),
                      BigText(text: "Product Name", weight: FontWeight.bold,),
                      SizedBox(height: ResponsiveDim.height10,),
                      SmallText(text: 'English', size: ResponsiveDim.bigFont, color: Colors.black,),
                      SizedBox(height: ResponsiveDim.height10,),
                      TextField(
                        controller: _productNameEnglishController,
                        onChanged: (value) {
                          _updateContinueButtonState(); // Update button state when English name changes
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          hintText: 'Enter product name in english ',
                        ),
                      ),
                      SizedBox(height: ResponsiveDim.height10,),
                      SmallText(text: 'Nepali', size: ResponsiveDim.bigFont, color: Colors.black,),
                      SizedBox(height: ResponsiveDim.height10,),
                      TextField(
                        controller: _productNameNepaliController,
                        onChanged: (value) {
                          _updateContinueButtonState(); // Update button state when English name changes
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          hintText: 'Enter product name in dev nagari ',
                        ),
                      ),
                      SizedBox(height: ResponsiveDim.height15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SmallText(text: 'Category', size: ResponsiveDim.bigFont, color: Colors.black,),
                          GestureDetector(
                            onTap:() =>_showCategoryDialog(),
                            child: Icon(
                              Icons.edit,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),

                      Container(
                        width: ResponsiveDim.screenWidth,
                        height: ResponsiveDim.height45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            "${selectedCategoryName ?? 'Select category'} - ${selectedSubcategoryName ?? 'Select subcategory'}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: ResponsiveDim.height15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: ResponsiveDim.height10,),
                      SmallText(text: 'Images', size: ResponsiveDim.bigFont, color: Colors.black,),
                      SizedBox(height: ResponsiveDim.height5,),
                      Text(
                        'Upload images from multiple angles. Product with high quality images helps to get more views.',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: ResponsiveDim.height15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: ResponsiveDim.height5,),
                      SizedBox(
                        width: ResponsiveDim.screenWidth,
                        height: 150,
                        child: DottedBorder(
                          color: Colors.red,
                          strokeWidth: 2,
                          dashPattern: [15],
                          radius: Radius.circular(8.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: ResponsiveDim.screenWidth,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Color(0xFFD9D9D9),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: imageFiles.isEmpty
                                    ? Center(
                                  child: Text(
                                    'No image selected',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )
                                    : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: imageFiles.length,
                                  itemBuilder: (ctx, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Image.file(
                                            imageFiles[index],
                                            height: 90,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                imageFiles.removeAt(index);
                                              });
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              imageFiles.isNotEmpty ? Positioned(
                                bottom: -6,
                                child: CustomButton(
                                  buttonText: "Add more images",
                                  height: 40,
                                  onPressed: () => _uploadImage(),
                                ),
                              ) : Positioned(
                                child: CustomButton(
                                  buttonText: "Upload image",
                                  onPressed: () => _uploadImage(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CustomButton(
                        buttonText: "Continue",
                        onPressed: isContinueButtonEnabled ? () {
                          productNameEnglish=_productNameEnglishController.text;
                          productNameNepali=_productNameNepaliController.text;
                          print(productNameEnglish);
                          print(productNameNepali);
                          print("Store_id is");
                          print(storeId);
                          print(categoryID);
                          print(subCategoryID);
                          print(imageFiles);
                          print(imageBytesList);
                          Navigator.pushNamed(context, 'addProduct2');

                        } : () {}, // Add an empty function as a fallback
                        width: ResponsiveDim.screenWidth,
                        color: isContinueButtonEnabled ? null : Colors.grey, // Change button color based on enabled state
                      ),


                      SizedBox(height: ResponsiveDim.height5,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

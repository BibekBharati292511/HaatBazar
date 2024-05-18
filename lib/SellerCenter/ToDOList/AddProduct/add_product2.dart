import 'package:flutter/material.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';
import 'package:hatbazarsample/Widgets/smallText.dart';
import 'package:hatbazarsample/Widgets/progress_indicator.dart';
import 'package:intl/intl.dart';

import '../../../Widgets/product_availability_widget.dart';
import '../../../main.dart';

class AddProductPage2 extends StatefulWidget {
  const AddProductPage2({Key? key}) : super(key: key);

  @override
  _AddProductPageState2 createState() => _AddProductPageState2();
}

class _AddProductPageState2 extends State<AddProductPage2> {
  late TextEditingController productHighlightsController;
  late TextEditingController productDescriptionController;
  late TextEditingController productRateController;
  bool isContinueButtonEnabled = false;
  late String selectedUnit;
  List<String> units = ['Kg', 'Lb', 'Piece'];

  @override
  void initState() {
    super.initState();
    productHighlightsController = TextEditingController();
    productDescriptionController = TextEditingController();
    productRateController = TextEditingController();
    productHighlights = '';
    productDescription = '';
    productRate = '';
    availabilityInfo = '';
    selectedUnit = units[0];
  }

  @override
  void dispose() {
    productHighlightsController.dispose();
    productDescriptionController.dispose();
    productRateController.dispose();
    super.dispose();
  }

  void _openInputDialog(String title, String hintText, TextEditingController controller, {int maxLines = 1, int maxBulletPoints = 5}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline, // Set the action for Enter key
            decoration: InputDecoration(
              hintText: hintText,
            ),
            onChanged: (text) {
              if (text.isNotEmpty) {
                // Split the text into lines
                List<String> lines = text.split('\n');

                // Limit the number of lines (bullet points) to maxBulletPoints
                if (lines.length > maxBulletPoints) {
                  // Join only the first maxBulletPoints lines
                  String newText = lines.sublist(0, maxBulletPoints).join('\n');
                  controller.value = controller.value.copyWith(
                    text: newText, // Set the new text
                    selection: TextSelection.collapsed(offset: newText.length), // Keep cursor at the end
                  );
                }
              }
              _updateContinueButtonState(); // Update continue button state
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform actions with entered value
                if (title == 'Product Highlights') {
                  setState(() {
                    productHighlights = controller.text;
                  });
                } else if (title == 'Product Description') {
                  setState(() {
                    productDescription = controller.text;
                  });
                } else if (title == 'Product Rate') {
                  setState(() {
                    productRate = controller.text;
                  });
                }
                _updateContinueButtonState(); // Update continue button state
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateContinueButtonState() {
    setState(() {
      isContinueButtonEnabled = productHighlights.isNotEmpty &&
          productDescription.isNotEmpty &&
          productRate.isNotEmpty &&
          availabilityInfo.isNotEmpty;
    });
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
                title: const Text('Add product'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProgressIndicators(
                        currentPage: 2,
                        totalPages: 3,
                        pageName: 'Specification',
                      ),
                      SizedBox(height: ResponsiveDim.height15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SmallText(
                            text: 'Product Highlights',
                            size: ResponsiveDim.bigFont,
                            color: Colors.black,
                          ),
                          GestureDetector(
                            onTap: () => _openInputDialog(
                              'Product Highlights',
                              'Enter product highlights (use bullet points)',
                              productHighlightsController,
                              maxLines: 5,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          width: ResponsiveDim.screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            productHighlights.isNotEmpty
                                ? productHighlights
                                : 'Describe your product in a few bullet points',
                            style: TextStyle(
                              fontSize: ResponsiveDim.height15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveDim.height10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SmallText(
                            text: 'Product Description',
                            size: ResponsiveDim.bigFont,
                            color: Colors.black,
                          ),
                          GestureDetector(
                            onTap: () => _openInputDialog(
                              'Product Description',
                              'Give detailed description of the product',
                              productDescriptionController,
                              maxLines: 15,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          width: ResponsiveDim.screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            productDescription.isNotEmpty
                                ? productDescription
                                : 'Detail product description',
                            style: TextStyle(
                              fontSize: ResponsiveDim.height15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveDim.height15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SmallText(
                            text: 'Product Rate',
                            size: ResponsiveDim.bigFont,
                            color: Colors.black,
                          ),

                        ],
                      ),
                      SizedBox(height: ResponsiveDim.height10,),
                      Container(
                        color: Colors.white,
                        width: ResponsiveDim.screenWidth,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: productRateController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Enter price',
                                ),
                                onChanged: (value) {
                                  productRate=productRateController.text;
                                  priceUnit=selectedUnit;
                                  _updateContinueButtonState();
                                },
                              ),
                            ),
                            SizedBox(width: ResponsiveDim.width15),
                            // Dropdown menu for selecting unit
                            DropdownButton<String>(
                              value: selectedUnit,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedUnit = newValue!;
                                  productRate= productRateController.text;
                                  priceUnit=selectedUnit;
                                  _updateContinueButtonState();
                                });
                              },
                              items: units.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: ResponsiveDim.height10),
                      SizedBox(height: ResponsiveDim.height15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SmallText(
                            text: 'Product Availability',
                            size: ResponsiveDim.bigFont,
                            color: Colors.black,
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AvailabilityDialog(
                                    onSelected: (String season, double qty, String unit, String date) {
                                      setState(() {
                                        availabilityInfo = 'Season: $season\nQuantity: $qty $unit\nAvailable till: $date';
                                        availableQty=qty;
                                        harvestedSeason=season;
                                        DateTime newDate=DateFormat('MMM d, yyyy').parse(date);
                                        String formattedDate=DateFormat('yyyy-MM-dd').format(newDate);
                                        
                                        date= formattedDate;
                                        availableDate=date;
                                        qtyUnit=unit;
                                        _updateContinueButtonState();
                                      });
                                    },
                                  );
                                },
                              );
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: ResponsiveDim.screenWidth,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            availabilityInfo.isNotEmpty
                                ? availabilityInfo
                                : 'Choose harvest seasons and availability',
                            style: TextStyle(
                              fontSize: ResponsiveDim.height15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveDim.height5),
                      isContinueButtonEnabled?
                      CustomButton(
                        buttonText: "Continue",
                        onPressed: () {
                          // Print all the stored data when continue button is pressed
                          print('Product Highlights: $productHighlights');
                          print('Product Description: $productDescription');
                          print('Product Rate: $productRate');
                          print('new product rate os $productRate');
                          print('unit is $selectedUnit');
                          print('Availability Info: $availabilityInfo');
                          print('cate id is $categoryID');

                          Navigator.pushNamed(context, 'productConfirmation');
                        },
                        width: ResponsiveDim.screenWidth,
                      ):CustomButton(buttonText: 'Continue', onPressed: (){
                        print('rate is $productRate');
                      },width: ResponsiveDim.screenWidth,color: Colors.grey,),

                      SizedBox(height: ResponsiveDim.height5),
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

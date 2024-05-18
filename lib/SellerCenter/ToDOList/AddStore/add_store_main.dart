import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';
import 'package:hatbazarsample/main.dart';

import '../../../Model/storeTracker.dart';
import '../../../Widgets/alertBoxWidget.dart';

class AddStorePage extends StatefulWidget {
  const AddStorePage({super.key});

  @override
  State<AddStorePage> createState() => _AddStorePageState();
}

class _AddStorePageState extends State<AddStorePage> {
  bool isLoading = true; // Add a loading indicator state

  @override
  void initState() {
    super.initState();
    _fetchStoreProfileCompletion();
  }

  Future<void> _fetchStoreProfileCompletion() async {
    await StoreProfileCompletionTracker.storeProfileCompletionTracker();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: AppColors.backgroundColor,
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: AppColors.backgroundColor,
                    title: const Text("Add Store"),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back), // The back button icon
                      onPressed: () {
                        Navigator.pushNamed(context, 'sellerHomePage'); // This will navigate back to the previous page
                      },
                    ),
                  ),
                  Container(
                    //   color: AppColors.backgroundColor,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: ResponsiveDim.width15,
                        right: ResponsiveDim.width15,
                        top: ResponsiveDim.height10,
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(ResponsiveDim.radius6),
                              ),
                              //color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Set up your store and kick start your selling journey ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "poppins",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: ResponsiveDim.height15),
                                ButtonContainer(
                                  number: "1",
                                  text: "Set up store",
                                  tracker: isStoreProfileCompleted,
                                ),
                                SizedBox(height: ResponsiveDim.height10),
                                ButtonContainer(
                                  number: "2",
                                  text: "Add Address",
                                  tracker: isStoreAddressCompleted,
                                ),
                                SizedBox(height: ResponsiveDim.height10),
                                ButtonContainer(
                                  number: "3",
                                  text: "Add Delivery Option",
                                  tracker: isStoreDeliveryOptionCompleted,
                                ),
                                SizedBox(height: ResponsiveDim.height10),
                                ButtonContainer(
                                  number: "4",
                                  text: "Add Payment choice",
                                  tracker: isStorePaymentOptionCompleted,
                                ),
                                SizedBox(height: ResponsiveDim.height10),
                                ButtonContainer(
                                  number: "5",
                                  text: "Add Store Contact",
                                  tracker:  isAddStoreNumberCompleted
                                ),
                                SizedBox(height: ResponsiveDim.height10),
                                ButtonContainer(
                                  number: "6",
                                  text: "Add Store Image",
                                  tracker: isAddStoreImageCompleted,
                                ),
                                SizedBox(height: ResponsiveDim.height45),
                                const Text(
                                  "@Haatbazar 2024 all rights reserved",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "poppins",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
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
}

class HeaderContainer extends StatelessWidget {
  final String text;

  const HeaderContainer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      color: Colors.white,
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.black,
            fontFamily: "poppins",
            fontWeight: FontWeight.w400),
      ),
    );
  }
}

class ButtonContainer extends StatelessWidget {
  final String number;
  final String text;
  final bool tracker;

  const ButtonContainer(
      {super.key,
      required this.number,
      required this.text,
      required this.tracker});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          tracker == false
              ? Container(
                  width: 30.0,
                  height: ResponsiveDim.height45,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFA20202),
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : const Icon(Icons.check_circle, color: AppColors.primaryColor),
          const SizedBox(width: 10.0),
          Expanded(
            child: SizedBox(
              height: ResponsiveDim.height45,
              child: ElevatedButton(
                onPressed: () {
                  switch (text) {
                    case "Set up store":
                      navigator?.pushNamed('storeType');
                      break;
                    case "Add Address":
                      print(isStoreProfileCompleted);
                      if(isStoreProfileCompleted) {
                        Navigator.pushNamed(context, 'storeAddress');
                      }
                      else{
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext dialogContext) {
                            return MyAlertDialog(
                              title: 'Error',
                              content: "Create your store first",
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'storeType');
                                  },
                                  child: const Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      break;
                    case "Add Delivery Option":
                      if(isStoreProfileCompleted) {
                        Navigator.pushNamed(context, 'storeDeliveryOptions');
                      }
                      else{
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext dialogContext) {
                            return MyAlertDialog(
                              title: 'Error',
                              content: "Create your store first",
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'storeType');
                                  },
                                  child: const Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );
                      }

                      break;
                    case "Add Payment choice":
                      if(isStoreProfileCompleted) {
                        Navigator.pushNamed(context, 'storePaymentOptions');
                      }
                      else{
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext dialogContext) {
                            return MyAlertDialog(
                              title: 'Error',
                              content: "Create your store first",
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'storeType');
                                  },
                                  child: const Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );
                      }

                      break;
                    case "Add Store Contact":
                      Navigator.pushNamed(context, 'createSellerAccount');
                      fromUser=false;
                      fromStore=true;
                      break;
                    case "Add Store Image":
                      Navigator.pushNamed(context, 'editProfileImage');
                      fromUser=false;
                      fromStore=true;
                      break;
                    default:
                      // Handle other cases if needed
                      break;
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      tracker ? Colors.green : const Color(0xFFA20202),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "poppins",
                          fontWeight: FontWeight.w400,
                          fontSize: ResponsiveDim.smallFont),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "View",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "poppins",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          width: ResponsiveDim.width5,
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        )
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

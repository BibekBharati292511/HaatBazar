
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/main.dart';

class ToDoListSeller extends StatefulWidget {
  const ToDoListSeller({super.key});

  @override
  State<ToDoListSeller> createState() => _ToDoListSellerState();
}

class _ToDoListSellerState extends State<ToDoListSeller> {
  @override
  Widget build(BuildContext context) {
    print("tracker is $isAddAddressCompleted");
    return  Container(
      color: AppColors.backgroundColor,
      child: Padding(
          padding: EdgeInsets.only(left: ResponsiveDim.width15,right: ResponsiveDim.width15,top: ResponsiveDim.height10),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(ResponsiveDim.radius6)),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                        "Complete to do list to kick start your selling journey at haat bazar",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "poppins",
                      fontWeight: FontWeight.w400,
                    fontSize: ResponsiveDim.smallFont,
                  ),
                    ),
                    SizedBox(height: ResponsiveDim.height10),
                    ButtonContainer(number: "1", text: "Complete Profile",tracker: isProfileCompleted,),
                    SizedBox(height: ResponsiveDim.height10),
                    ButtonContainer(number: "2", text: "Add Address",tracker: isAddAddressCompleted,),
                    SizedBox(height: ResponsiveDim.height10),
                    ButtonContainer(number: "3", text: "Add Store",tracker: isAddStoreCompleted,),
                    SizedBox(height: ResponsiveDim.height10),
                    ButtonContainer(number: "4", text: "Add Bank Account",tracker: isAddBankAccountCompleted,),
                    SizedBox(height: ResponsiveDim.height10),
                    ButtonContainer(number: "5", text: "Add a product",tracker: isAddProductCompleted,),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveDim.height15,),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(ResponsiveDim.radius6)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                            Icons.facebook_outlined,
                          color: Colors.blue,
                        ),
                        SizedBox(width: ResponsiveDim.width10,),
                        Text(
                          "Join our facebook Group",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "poppins",
                            fontWeight: FontWeight.w400,
                            fontSize: ResponsiveDim.font24,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveDim.height10,),
                    const Text(
                      "Join facebook group of ‘Haat bazar ’for latest information updates, exclusive offers and be  a part of haat bazar community",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "poppins",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveDim.height15,),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(ResponsiveDim.radius6)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.email_rounded,
                          color: Colors.red,
                        ),
                        SizedBox(width: ResponsiveDim.width10,),
                        Text(
                          "Email us for Inquiry",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "poppins",
                            fontWeight: FontWeight.w400,
                            fontSize: ResponsiveDim.font24,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveDim.height10,),
                    const Text(
                      "Contact us at “hatbazarCustomerSupport@gmail.com” for help and support",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontFamily: "poppins",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveDim.height20),
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

  const ButtonContainer({super.key, required this.number, required this.text,required this.tracker});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
            tracker == false ? Container(
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
                    case "Complete Profile":
                      navigator?.pushNamed('completeProfile');
                      break;
                    case "Add Address":
                      Navigator.pushNamed(context, 'mapScreen');
                      break;
                    case "Add Store":
                      Navigator.pushNamed(context, 'addStore');
                      break;
                    case "Add Bank Account":
                      break;
                    case "Add a product":
                      break;
                    default:
                    // Handle other cases if needed
                      break;
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: tracker ?Colors.green:const Color(0xFFA20202),
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
                        fontSize: ResponsiveDim.smallFont
                      ),


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
                        SizedBox(width: ResponsiveDim.width5,),
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

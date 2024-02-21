import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';

class ToDoListSeller extends StatefulWidget {
  const ToDoListSeller({super.key});

  @override
  State<ToDoListSeller> createState() => _ToDoListSellerState();
}

class _ToDoListSellerState extends State<ToDoListSeller> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: AppColors.backgroundColor,
      child: Padding(
          padding: EdgeInsets.only(left: ResponsiveDim.width15,right: ResponsiveDim.width15,top: ResponsiveDim.height10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
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
                    ButtonContainer(number: "1", text: "Complete Profile"),
                    SizedBox(height: ResponsiveDim.height10),
                    ButtonContainer(number: "2", text: "Add Address"),
                    SizedBox(height: ResponsiveDim.height10),
                    ButtonContainer(number: "3", text: "Add Store"),
                    SizedBox(height: ResponsiveDim.height10),
                    ButtonContainer(number: "4", text: "Add Bank Account"),
                    SizedBox(height: ResponsiveDim.height10),
                    ButtonContainer(number: "5", text: "Add a product"),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveDim.height15,),
              Container(
                padding: EdgeInsets.all(20.0),
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
                    Text(
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
                padding: EdgeInsets.all(20.0),
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
                    Text(
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

  HeaderContainer({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      color: Colors.white,
      child: Text(
        text,
        style: TextStyle(
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

  ButtonContainer({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Container(
            width: 30.0,
            height: ResponsiveDim.height45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFA20202),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Container(
              height: ResponsiveDim.height45,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA20202),
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
                        Text(
                            "View",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "poppins",
                          fontWeight: FontWeight.w400,
                      ),
                        ),
                        SizedBox(width: ResponsiveDim.width5,),
                        Icon(
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

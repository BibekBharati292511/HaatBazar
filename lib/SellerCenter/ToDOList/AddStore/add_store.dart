import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hatbazarsample/Widgets/smallText.dart';

import '../../../Utilities/ResponsiveDim.dart';
import '../../../Utilities/colors.dart';
import '../../../Widgets/bigText.dart';
import '../../../Widgets/profile_image_widget.dart';
import '../../../main.dart';
import '../CompleteProfile/complete_profile_main.dart';

class AddStorePage extends StatefulWidget {
  const AddStorePage({Key? key}) : super(key: key);

  @override
  _AddStorePageState createState() => _AddStorePageState();
}

class _AddStorePageState extends State<AddStorePage> {
  String? storePhoneNumber;
  bool isStepCompleted = false;
  // Define variables to store input values
  TextEditingController storeNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  // Add more controllers for other fields...
  int currentStep = 0;
  int stepTracker = 1;

  MaterialStateColor _stepColor(Set<MaterialState> states) {
    return MaterialStateColor.resolveWith((states) {
      if (states.contains(MaterialState.disabled) && isStepCompleted) {
        return Colors.black;
      }
      if (states.contains(MaterialState.disabled)) {
        return Colors.red;
      } else if (states.contains(MaterialState.selected)) {
        return Colors.green;
      }

      return Colors.yellow; // Default color
    });
  }

  @override
  Widget build(BuildContext context) {
    // Reset isStepCompleted to false at the beginning of the build method
    isStepCompleted = false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text('Add Store'),
        titleTextStyle: TextStyle(
          fontFamily: "Poppins",
          color: Colors.black,
          fontSize: ResponsiveDim.bigFont,
        ),
      ),
      body: Container(
        color: AppColors.backgroundColor,
        child: Stepper(
          connectorColor: _stepColor({MaterialState.pressed}),
          currentStep: currentStep,
          onStepCancel: () {
            currentStep > 0 ? setState(() => currentStep -= 1) : null;
          },
          onStepContinue: () {
            setState(() {
              if (currentStep < 3 - 1) {
                currentStep += 1;
                stepTracker += 1;
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmationPage(),
                  ),
                );
              }
            });
          },
          steps: [
            Step(
              title: SmallText(text: "Store Information", size: 18, color: _getColor(0)),
              content: Column(
                children: [
                  SizedBox(height: 5),
                  TextFormField(
                    controller: storeNameController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: 'Store Name',
                    ),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),

                ],

              ),
              isActive: currentStep == 0,
              state: _getState(0),
            ),
            Step(
              title: Text('Location & Contact', style: TextStyle(color: _getColor(1))),
              content: Column(
                children: [
                  // Add address input fields
                  ClickableContainer(
                    onPressed: () {
                      Navigator.pushNamed(context, "createSellerAccount");
                    },
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BigText(text: "Store Number", weight: FontWeight.bold, color: Colors.black38),
                        SizedBox(height: ResponsiveDim.height5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SmallText(text: storePhoneNumber?? "Set phone number", size: ResponsiveDim.font24, color: Colors.black),
                            const Icon(Icons.arrow_forward_ios_outlined)
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveDim.height10,),
                  ClickableContainer(
                    onPressed: () {
                      Navigator.pushNamed(context, "mapScreen");
                    },
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BigText(text: "Address", weight: FontWeight.bold, color: Colors.black38),
                        SizedBox(height: ResponsiveDim.height5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: SmallText(text: "Set phone number",  color: Colors.black,overFlow: TextOverflow.ellipsis,)),
                            const Icon(Icons.arrow_forward_ios_outlined)
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Add operating hours input field
                  // Add social media links input fields
                ],
              ),
              isActive: currentStep == 1,
              state: _getState(1),
            ),
            Step(
              title: Text('Payment & Delivery Options', style: TextStyle(color: _getColor(2))),
              content: Column(
                children: [
                  // Add payment methods checkboxes or dropdown
                  // Add delivery options checkboxes or dropdown
                  // Add delivery details input fields
                  // Add pickup options checkboxes or dropdown
                  // Add pickup details input fields
                ],
              ),
              isActive: currentStep == 2,
              state: _getState(2),
            ),
          ],
        ),
      ),
    );
  }

  // Function to determine the color of each step
  Color _getColor(int step) {
    if (currentStep >= step ) {
      print("step is $step");
      print(currentStep);
      isStepCompleted = true;
      return Colors.green;
    } else {
      return Colors.redAccent; // Using the theme's disabled color
    }
  }

  // Function to determine the state of each step
  StepState _getState(int step) {
    if (currentStep == step) {
      print(StepState.indexed);
      return StepState.indexed;
    } else if (currentStep > step) {
      print(StepState.complete);
      return StepState.complete;
    } else {
      return StepState.disabled;
    }
  }
}


class ConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 20),
            const Text(
              'Store added successfully!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the previous screen
                Navigator.pop(context);
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

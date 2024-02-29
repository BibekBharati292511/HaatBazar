import 'package:flutter/material.dart';
import 'package:hatbazarsample/Model/store_model.dart';
import 'package:hatbazarsample/main.dart';

import '../../../Utilities/ResponsiveDim.dart';
import '../../../Widgets/custom_button.dart';
import '../../../Widgets/loginBackgroundImage.dart';
import '../../../Widgets/login_container.dart';
import '../../../Widgets/progress_indicator.dart';
import '../../../Widgets/radio_box.dart';

class StoreTypePage extends StatefulWidget {
  const StoreTypePage({super.key});

  @override
  State<StoreTypePage> createState() => _StoreTypePageState();
}

class _StoreTypePageState extends State<StoreTypePage> {
  String? _selectedOption;
  int? _selectedTypeId;
  String? description;
  late Future<List<StoreType>> _typesFuture;

  @override
  void initState() {
    super.initState();
    _typesFuture = fetchTypes();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            const LoginBackgroundImage(),
            Center(
              child: LoginContainer(
                children: <Widget>[
                  SizedBox(height: ResponsiveDim.height45),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context); // Navigate back
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Select Store Type',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ResponsiveDim.font24,
                              fontWeight: FontWeight.bold,
                              fontFamily: "poppins"
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveDim.height20),
                  const ProgressIndicators(currentPage: 1, totalPages: 2),
                  SizedBox(height: ResponsiveDim.height20),
                  const Text(
                    'What is your store type?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description??"",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  FutureBuilder<List<StoreType>>(
                    future: _typesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        if (_selectedOption == null) {
                          // If no role is selected, set the default role here
                          _selectedOption = snapshot.data!.first.type;
                          _selectedTypeId = snapshot.data!.first.id;
                        }
                        return Padding(
                          padding: EdgeInsets.only(left: ResponsiveDim.width45, top: ResponsiveDim.height10),
                          child: RadioBox(
                            options: snapshot.data!.map((type) => type.type).toList(),
                            selectedOption: _selectedOption,
                            onChanged: (String? typeName) {
                              setState(() {
                                _selectedOption = typeName;
                                _selectedTypeId = snapshot.data!.firstWhere((type) => type.type == typeName).id;
                                description='${snapshot.data!.firstWhere((type) => type.type == _selectedOption).description}';
                                print(description);
                              });
                            },
                          ),
                        );
                      }
                    },
                  ),

                  buildSignInButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSignInButton() {
    return CustomButton(
        buttonText: 'Continue',
        onPressed: () {
          storeTypeId=_selectedTypeId;
          print("selected_id is ");
          print(storeTypeId);
          // Navigate based on the selected role ID
          Navigator.pushNamed(context, 'createStore');

        }
    );
  }
}

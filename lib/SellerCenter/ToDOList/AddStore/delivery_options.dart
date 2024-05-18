import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:hatbazarsample/main.dart';

import '../../../Model/DeliveryOptions.dart';
import '../../../Model/ProfileCompletionTracker.dart';
import '../../../Model/UserAddress.dart';
import '../../../Model/UserData.dart';
import '../../../Model/addressTracker.dart';
import '../../../Utilities/ResponsiveDim.dart';
import '../../../Widgets/alertBoxWidget.dart';
import '../../../Widgets/custom_button.dart';
import '../../../Widgets/loginBackgroundImage.dart';
import '../../../Widgets/login_container.dart';
import 'package:http/http.dart' as http;
late ValueNotifier<Set<String>> _selectedOptionsController;

class storeDeliveryOptions extends StatefulWidget {
  const storeDeliveryOptions({Key? key}) : super(key: key);

  @override
  State<storeDeliveryOptions> createState() => _storeDeliveryOptionsState();

}

class _storeDeliveryOptionsState extends State<storeDeliveryOptions> {
  Set<String> _selectedOptions = {};
  String? _selectedDescription;
  late Future<List<StoreDeliveryOptions>> _deliveryOptionsFuture;
  Future<List<String>?> fetchStoreDeliveryOptions() async {
    final url = Uri.parse('${serverBaseUrl}storeDeliveryOptions/add');
    final payload = {
      "deliveryOptions": _selectedOptionsController.value.toList(),
      "token": userToken,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    if (response.statusCode == 200) {

      final List<String> options = [];
      final responseData = json.decode(response.body);
      // Extract options from responseData and add to options list
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(
            title: 'Success',
            content: "Delivery options added successfully",
            actions: [
              TextButton(
                onPressed: () async {
                  await ProfileCompletionTracker.profileCompletionTracker();
                  await AddressTracker.addressTracker();
                  await UserDataService.fetchUserData(userToken!).then((
                      userData) {
                    userDataJson = jsonDecode(userData);
                  });
                  await UserAddressService.fetchUserAddress(userDataJson["id"]).then((userAddress) {
                    userAddressJson = jsonDecode(userAddress);
                  });
                  userAddress=userAddressJson["address"];
                  Navigator.pushNamed(context, 'addStore');
                  isStoreAddressCompleted=true;
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      return options;
    }
    else if(response.statusCode == 400){
      print("hepp here");
      print("hepp here");
      print(userDataJson["id"]);
      Map<String, dynamic> responseData = jsonDecode(response.body);
      // if (!context.mounted) return;
      //if (responseData['status'] == 'Error') {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return MyAlertDialog(
              title: 'Error',
              content: responseData['message'],
            );
          },
        );
    }
    else {
      throw Exception('Failed to fetch delivery options');
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _selectedOptionsController = ValueNotifier<Set<String>>({});
    _deliveryOptionsFuture = fetchDeliveryOptions() ;
  }
  @override
  void dispose() {
    _selectedOptionsController.dispose();
    super.dispose();
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
                          'Select Delivery Option',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ResponsiveDim.font24,
                              fontWeight: FontWeight.bold,
                              fontFamily: "poppins"),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: ResponsiveDim.height20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: FutureBuilder<List<StoreDeliveryOptions>>(
                      future: _deliveryOptionsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final deliveryOptions = snapshot.data!;
                          if (_selectedOptions.isEmpty && deliveryOptions.isNotEmpty) {
                            // If no option is selected, set the default option here
                           // _selectedOptions.add(deliveryOptions.first.deliveryOptions!);
                            _selectedDescription = deliveryOptions.first.description;
                          }
                          return Column(
                            children: [
                              for (var option in deliveryOptions)
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _selectedOptions.contains(option.deliveryOptions),

                                      onChanged: (isChecked) {
                                        setState(() {
                                          if (isChecked!) {
                                            _selectedOptions.add(
                                                option.deliveryOptions);
                                            _selectedOptionsController.value
                                                .add(option.deliveryOptions!);
                                          } else {
                                            _selectedOptions.remove(option.deliveryOptions);
                                            _selectedOptionsController.value.remove(option.deliveryOptions);
                                          }
                                          // Update description based on selected options
                                          _updateDescription(deliveryOptions);
                                        });
                                      },
                                    ),
                                    Text(option.deliveryOptions!),
                                  ],
                                ),
                              if (_selectedDescription != null)
                                Text(
                                  '$_selectedDescription',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontFamily: "poppins",
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              buildSignInButton(),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateDescription(List<StoreDeliveryOptions> deliveryOptions) {
    _selectedDescription = deliveryOptions
        .where((option) => _selectedOptions.contains(option.deliveryOptions))
        .map((option) => option.description)
        .join('\n ');
  }

  Widget buildSignInButton() {
    return CustomButton(
        buttonText: 'Save',
        onPressed: () async{
          if (_selectedOptions.isNotEmpty) {
            // If no option is selected, set the default option here
            // _selectedOptions.add(deliveryOptions.first.deliveryOptions!);
            print(_selectedOptionsController.value);
            print("present sir");
            print(storeDataJson[0]["id"]);
            await fetchStoreDeliveryOptions();
            await AddressTracker.storeDeliveryTracker();
            addStoreStatsChecker();
          }
          // Handle save action here
        });
  }
}

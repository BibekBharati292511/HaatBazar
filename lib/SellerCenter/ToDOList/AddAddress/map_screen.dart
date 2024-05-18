import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hatbazarsample/Model/addressTracker.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/AddAddress/location_controller.dart';
import 'package:get/get.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';

import '../../../Model/ProfileCompletionTracker.dart';
import '../../../Model/UserAddress.dart';
import '../../../Model/UserData.dart';
import '../../../Utilities/ResponsiveDim.dart';
import '../../../Utilities/constant.dart';
import '../../../Widgets/alertBoxWidget.dart';
import '../../../Widgets/bigText.dart';
import '../../../main.dart';
import 'location_controller.dart';
import 'location_search_dialouge.dart';
import 'package:http/http.dart' as http;
class MapScreen extends StatefulWidget {
  final GoogleMapController? googleMapController;
  const MapScreen({super.key, this.googleMapController});

  @override
  State<MapScreen> createState() => _MapScreenState();
}
class _MapScreenState extends State<MapScreen> {
  late LatLng _initialPosition=LatLng(27.6995091, 85.4840780);
  late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;
  TextEditingController _addressController=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(Get.find<LocationController>().addressList.isEmpty){
      _initialPosition=LatLng(isAddAddressCompleted?userAddress["latitude"]:27.6995939, isAddAddressCompleted?userAddress["longitude"]:85.4840471);
      _cameraPosition=CameraPosition(target: _initialPosition,zoom: 17);
    }
    //else get the data from database and set latitude and longitude
    //for that we have already called get users data so just check if user address is empty
    // then set camera position
  }
  @override
  Widget build(BuildContext context) {
    Future<void> setAddress(
        final url ,Function method,String country, String county, double latitude, double longitude, String municipality, String state,String cityDistrict,int user_id) async {

      try {
        final response = await method(
          url,
          headers: <String, String>{"Content-Type": "application/json"},
          body: jsonEncode(<String, Object>{
            "country": country,
            "county": county,
            "latitude": latitude,
            "longitude": longitude,
            "municipality": municipality,
            "state": state,
            "cityDistrict": cityDistrict,
            "user_id": user_id
          }),
        );

        if (response.statusCode == 200) {
          // Decode the response JSON
          Map<String, dynamic> responseData = jsonDecode(response.body);
          if (!context.mounted) return;
          if (responseData['status'] == 'Error') {
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

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return MyAlertDialog(
                  title: 'Success',
                  content: "Address added successfully",
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
                        if(role=="Technicians"){
                          addTechnicianStatsChecker();
                          isTechnicianSetupCompleted?

                          Navigator.pop(context):
                              Navigator.pushNamed(context, 'technicianHome');
                        }
                        else {
                          Navigator.pushNamed(context, 'sellerHomePage');
                          isAddAddressCompleted = true;
                        }
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          // Handle other status codes (e.g., 400, 500) here
          throw Exception('Failed to add address: ${response.body}');
        }
      } catch (e) {
        // Handle network errors here
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return MyAlertDialog(title: 'Error', content: 'Failed to add address: $e');
          },
        );
      }
    }
    final LocationController locationController = Get.put(LocationController());
    _addressController.text="${locationController.placemark.name??''}"
        "${locationController.placemark.locality??''}"
        "${locationController.placemark.postalCode??''}"
        "${locationController.placemark.country??''}";
    print("address is :${_addressController.text}");
    return   Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Container(
          alignment: Alignment.centerLeft,
          child: BigText(
            text: "Set Address",
            size:30,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,size:30,), // Back button icon
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.black, // Icon color
          ),
        ),
      body: GetBuilder<LocationController>(builder: (LocationController){
        return SafeArea(
          child: Center(
            child: SizedBox(width: double.maxFinite,
              child: Stack(
                children: [
                  GoogleMap(initialCameraPosition: CameraPosition(target: _initialPosition,zoom: 17),
                    zoomControlsEnabled: true,
                    onCameraMove: (CameraPosition cameraPosition){
                      _cameraPosition=cameraPosition;
                    },
                    onCameraIdle: (){
                   //   Get.find<LocationController>().updatePosition(_cameraPosition,false);
                      LocationController.updatePosition(_cameraPosition,true);
                    },
                    onMapCreated: (GoogleMapController mapController){
                    _mapController=mapController;
                    locationController.setMapController(mapController);
                    },

                  ),
                  Center(
                    child:!locationController.loading?Icon(Icons.push_pin_rounded,color: Colors.red,size:54,):const CircularProgressIndicator(),
                  ),
                  Positioned(
                      top: ResponsiveDim.height45,
                      left: ResponsiveDim.width20,
                      right:ResponsiveDim.width20,
                      child:InkWell(
                        onTap: (){
                          print("tsp");
                       Get.dialog(LocationSearchDialog(mapController: _mapController));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: ResponsiveDim.width10),
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(ResponsiveDim.radius20/2),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on,size: 25,color:Colors.yellow,),
                              Expanded(child: Text(
                                "${locationController.placemark.name}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                              SizedBox(width: ResponsiveDim.width10,),
                              Icon(Icons.search,size: 30,color: Colors.yellow,)
                            ],
                          ),
                        
                        ),
                      )
                  ),
                  Positioned(
                      bottom: 60,
                      left: ResponsiveDim.width20,
                      right:ResponsiveDim.width20,
                      child: !isAddAddressCompleted?CustomButton(buttonText: 'Add Address', onPressed: () async {
                        await(setAddress(Uri.parse("${serverBaseUrl}address/add"),http.post,locationController.country, locationController.county, locationController.latitude, locationController.longitude, locationController.municipality, locationController.state, locationController.cityDistrict, userDataJson["id"]));
                      },width:250):CustomButton(buttonText: 'Set new Address', onPressed: () async {
                        await(setAddress(Uri.parse("${serverBaseUrl}address/updateAddress"),http.put,locationController.country, locationController.county, locationController.latitude, locationController.longitude, locationController.municipality, locationController.state, locationController.cityDistrict, userDataJson["id"]));
                      },width:250)),

                ],
              ),
            ),
          ),
        );

    }),
    );
  }
}

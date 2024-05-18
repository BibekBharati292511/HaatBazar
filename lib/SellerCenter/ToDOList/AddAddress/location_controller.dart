import 'dart:core';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:hatbazarsample/Widgets/alertBoxWidget.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_webservice/src/places.dart';

import '../../../main.dart';
import 'address_model.dart';
import 'location_service.dart';

class LocationController extends GetxController implements GetxService{
  Placemark _pickPlaceMark = Placemark();
  Placemark _placemark=Placemark();
  Placemark get placemark => _placemark;
  Placemark get pickPlaceMark=>_pickPlaceMark;
  bool _loading=false;
  late Position _position;
  late Position _pickPosition;
  List <AddressModel> _addressList=[];
  List<AddressModel> get addressList => _addressList;
  late List<AddressModel>_allAddressList;
  List<String>_addressTypeList=["home","office","Others"];
  int _addressTypeIndex=0;
  late Map<String,dynamic>_getAddress;
  Map get getAddress=>getAddress;
  late GoogleMapController _mapController;
  bool _changeAddress=true;
  late String userAddress;
  List<String> placeIds = [];
  late String country;
  late  String county;
  late  double latitude;
  late  double longitude;
  late String municipality;
  late  String state;
  late String cityDistrict;

  Position get position => _position;
  Position get pickPosition => _pickPosition;
  bool get loading => _loading;
  bool _updateAddressData=true;
  void setMapController(GoogleMapController mapController){
    _mapController=mapController;
  }



  List<Prediction> _predictionList = [];
  Future<List<Prediction>> searchLocation(BuildContext context, String text) async {
    if(text.isNotEmpty) {
      http.Response response = await getLocationData(text);
      var data = jsonDecode(response.body.toString());
      print("my status is "+data["status"]);
      print("THe data is $data");
      if ( data['status']== 'OK') {
        _predictionList = [];
        print("Pridiction is $_predictionList");
        print(data["place_id"]);
        data['predictions'].forEach((prediction) => _predictionList.add(Prediction.fromJson(prediction)));
        for (var prediction in data['predictions']) {
          String placeId = prediction['place_id'];
          placeIds.add(placeId);
        }
        print(placeIds);
      } else {

      }
    }
    return _predictionList;
  }
  setLocation(String placeID,String address,GoogleMapController mapController) async {
    _loading=true;
    PlacesDetailsResponse detail;
    final String apiUrl = "${serverBaseUrl}place/details";
    final String url = "$apiUrl?place_id=$placeID";
    http.Response response = (await http.get(Uri.parse(url)));
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    detail = PlacesDetailsResponse.fromJson(responseData);
    print("detail is");
    print(detail);
    print("Latitude is" );
    print(detail.result.geometry!.location.lng);
    _pickPosition=Position(
        longitude: detail.result.geometry!.location.lng,
        latitude: detail.result.geometry!.location.lat,
        timestamp: DateTime.now(),
        accuracy: 1,
        altitude: 1,
        heading: 1,
        speed:1,
        speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1);
    String _address=await getAddressfromGeoCode(
        LatLng(detail.result.geometry!.location.lat, detail.result.geometry!.location.lng)
    );
    _placemark=Placemark(name: _address);
    _pickPlaceMark=Placemark(name: _address);
    _changeAddress=false;
    print(responseData);
    if(!mapController.isNull){
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(
              detail.result.geometry!.location.lat,
              detail.result.geometry!.location.lng
          ),zoom: 17)
      ));
    }

    _loading=false;
    update();


  }

  void updatePosition(CameraPosition position, bool fromAddress) async{
    if(_updateAddressData){
      _loading=true;
      update();
      try{
        if(fromAddress){
          _position=Position(
              longitude: position.target.longitude,
              latitude: position.target.latitude,
              timestamp: DateTime.now(),
              accuracy: 1,
              altitude: 1,
              heading: 1,
              speed: 1,
              speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1);
        }
        else{
          _pickPosition=Position(
              longitude: position.target.longitude,
              latitude: position.target.latitude,
              timestamp: DateTime.now(),
              accuracy: 1,
              altitude: 1,
              heading: 1,
              speed: 1,
              speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1);

        }
        if(_changeAddress){
          String _address=await getAddressfromGeoCode(
              LatLng(position.target.latitude, position.target.longitude)
          );
          _placemark=Placemark(name: _address);
          _pickPlaceMark=Placemark(name: _address);
          print("place mark is ${_placemark}");
        }
        else{
          _changeAddress=true;
        }
      }
      catch(e){
        print(e);
      }
      _loading=false;
      update();
    }
  }
  Future<String> getAddressfromGeoCode(LatLng latLng) async {
    try {
      // Make an HTTP GET request to your backend server
      final response = await http.get(
        Uri.parse('${serverBaseUrl}address?lat=${latLng.latitude}&lon=${latLng.longitude}'),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response to get the address
        final decodedResponse = json.decode(response.body);
        if(decodedResponse['display_name']=="Unknown Location Found"){
          MyAlertDialog(title: 'Fail', content: 'No such location found',);
        }
        print(json.decode(response.body));
        final address = decodedResponse['display_name'];
        final address1=decodedResponse['address'];
        country=address1['country'];
        county=address1['county'];
        final lat=decodedResponse['lat'];
        latitude=double.tryParse(lat)!;
        final lng=decodedResponse['lon'];
        longitude=double.tryParse(lng)!;
        municipality=address1['municipality'];
        state=address1['state'];
        cityDistrict=address1["city_district"];
        print(latitude);
        print(longitude);
        print(municipality);
        print(state);
        print(cityDistrict);
        userAddress=address;
        update();
        print(country);
        print(county);
        return address;
      } else {
        // Handle errors if any
        throw Exception('Failed to fetch address');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      showDialog(
        context: Get.overlayContext!,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Location cannot be found'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return 'Unknown Location Found';
    }

  }
  void clearAddressList(){
    _addressList=[];
    _allAddressList=[];
    update();
  }




}
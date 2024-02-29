import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/AddAddress/location_controller.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/main.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  TextEditingController _addresssController=TextEditingController();
  final TextEditingController _contactPersonName=TextEditingController();
  final TextEditingController _contactPersonNumber=TextEditingController();
  late bool _isLogged;
  late   CameraPosition _cameraPosition =const CameraPosition(target: LatLng(
    45.5153, -122.677433
  ),zoom: 17);
  late LatLng _initialPosition=LatLng(
      45.5153, -122.677433
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(userEmail!=null){
      _isLogged=true;
    }
    if(Get.find<LocationController>().addressList.isNotEmpty){
      _cameraPosition=CameraPosition(target: LatLng(
        double.parse(Get.find<LocationController>().getAddress["latitude"]),
          double.parse(Get.find<LocationController>().getAddress["longitude"])
      ));
      _initialPosition=LatLng(
          double.parse(Get.find<LocationController>().getAddress["latitude"]),
          double.parse(Get.find<LocationController>().getAddress["longitude"]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Address Page"),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: GetBuilder<LocationController>(builder: (LocationController){

        return Column(
          children: [
            Container(
              height:140,
              width:MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 5,right: 5,top: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      width: 2,color: Theme.of(context).primaryColor

                  )
              ),
              child: Stack(
                children: [
                  GoogleMap(initialCameraPosition:CameraPosition(target: _initialPosition,zoom: 17),
                    compassEnabled: false,
                    indoorViewEnabled: true,
                    mapToolbarEnabled: false,
                    onCameraIdle: (){
                    LocationController.updatePosition(_cameraPosition,true);
                    },
                    onCameraMove: ((position)=>_cameraPosition=position),
                    onMapCreated: (GoogleMapController controller){
                    LocationController.setMapController(controller);
                    },
                  )
                ],
              ),
            )

          ],
        );
      },
      ),
    );
  }
}

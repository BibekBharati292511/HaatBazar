import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hatbazarsample/Model/addressTracker.dart';
import 'package:hatbazarsample/Model/UserAddress.dart';
import 'package:hatbazarsample/SellerCenter/ToDOList/AddAddress/location_controller.dart';
import 'package:get/get.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';

class ViewAddressPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const ViewAddressPage({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<ViewAddressPage> createState() => _ViewAddressPageState();
}

class _ViewAddressPageState extends State<ViewAddressPage> {
  late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;

  @override
  void initState() {
    super.initState();
    _cameraPosition = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 17,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "View Address",
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _cameraPosition,
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController mapController) {
                    _mapController = mapController;
                  },
                ),
                Center(
                  child: Icon(
                    Icons.push_pin_rounded,
                    color: Colors.red,
                    size: 54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

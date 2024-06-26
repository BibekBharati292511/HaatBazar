import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import 'location_controller.dart';

class LocationSearchDialog extends StatelessWidget {
  final GoogleMapController? mapController;
  const LocationSearchDialog({Key? key, required this.mapController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Container(
      margin: EdgeInsets.only(top: 150),
      padding: EdgeInsets.all(5),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: SizedBox(
          width: 350,
          child: SingleChildScrollView(
            child: TypeAheadField(
              // Utilizing the builder property directly
              builder: (BuildContext context, TextEditingController? controller, FocusNode? focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  obscureText: false, // You can adjust this as needed
                  decoration: InputDecoration(
                    hintText: 'search_location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(style: BorderStyle.none, width: 0),
                    ),
                    hintStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 16,
                      color: Theme.of(context).disabledColor,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    labelText: 'search',
                  ),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 20,
                  ),
                );
              },
              suggestionsCallback: (pattern) async {
                return await Get.find<LocationController>().searchLocation(context, pattern);
              },
              itemBuilder: (context, Prediction suggestion) {
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(Icons.location_on),
                      Expanded(
                        child: Text(
                          suggestion.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline2?.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              onSelected: (Prediction suggestion) {
                Get.find<LocationController>().setLocation(suggestion.placeId!, suggestion.description!, mapController!);
                Get.back();
              },
            ),
          ),
        ),
      ),
    );
  }
}

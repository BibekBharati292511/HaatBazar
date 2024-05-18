import 'package:flutter/material.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';
import 'package:intl/intl.dart';

class AvailabilityDialog extends StatefulWidget {
  final Function(String, double, String, String) onSelected;

  const AvailabilityDialog({Key? key, required this.onSelected})
      : super(key: key);

  @override
  _AvailabilityDialogState createState() => _AvailabilityDialogState();
}

class _AvailabilityDialogState extends State<AvailabilityDialog> {
  String selectedHarvestSeason = "Spring"; // Default to Spring
  double selectedAvailableQty = 1.0; // Default quantity
  String selectedUnit = "kgs"; // Default unit
  late DateTime selectedAvailableDate; // Initialize with current date

  @override
  void initState() {
    super.initState();
    selectedAvailableDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Availability',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w400,
                    fontFamily: 'poppins'
                ),
              ),
              const SizedBox(height: 15.0),
              DropdownButtonFormField<String>(
                value: selectedHarvestSeason,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      selectedHarvestSeason = value;
                    });
                  }
                },
                items: <String>['Spring', 'Summer', 'Fall', 'Winter']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 18.0), // Increased font size
                    ),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Harvest Season',labelStyle: TextStyle(fontSize: 20.0,fontFamily: 'poppins'),),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      initialValue: selectedAvailableQty.toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (String value) {
                        setState(() {
                          selectedAvailableQty = double.parse(value);
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        labelStyle: TextStyle(fontSize: 20.0,fontFamily: 'poppins'), // Increased font size
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: selectedUnit,
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            selectedUnit = value;
                          });
                        }
                      },
                      items: <String>['kgs', 'grams', 'lbs']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 18.0), // Increased font size
                          ),
                        );
                      }).toList(),
                      decoration: const InputDecoration(labelText: 'Unit',labelStyle: TextStyle(fontSize: 20.0,fontFamily: 'poppins'),),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              ListTile(
                title: Text(
                  'Available till: ${DateFormat.yMMMd().format(selectedAvailableDate)}',
                  style: const TextStyle(fontSize: 18.0), // Increased font size
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedAvailableDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != selectedAvailableDate) {
                    setState(() {
                      selectedAvailableDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 20.0),
              CustomButton(buttonText: 'Save',onPressed: (){widget.onSelected(selectedHarvestSeason, selectedAvailableQty, selectedUnit,
                    DateFormat.yMMMd().format(selectedAvailableDate));
                Navigator.pop(context);},),

            ],
          ),
        ),
      ),
    );
  }
}

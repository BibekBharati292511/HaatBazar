import 'package:flutter/material.dart';
import 'package:hatbazarsample/AgroTechnicians/ToDoTechnician/setting_services.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';

class SetChargePerHourPage extends StatefulWidget {
  final int id;

  const SetChargePerHourPage({Key? key, required this.id}) : super(key: key);

  @override
  _SetChargePerHourPageState createState() => _SetChargePerHourPageState();
}

class _SetChargePerHourPageState extends State<SetChargePerHourPage> {
  final TechnicianSettingServices _services = TechnicianSettingServices();
  final TextEditingController _chargePerHourController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controller when the widget is removed from the widget tree
    _chargePerHourController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Set Charge Per Hour",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'technicianProfile');
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Set your charge per hour",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _chargePerHourController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Charge per hour",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            CustomButton(
              buttonText: "Save",
              onPressed: () async {
                double? chargePerHour = double.tryParse(
                    _chargePerHourController.text);

                if (chargePerHour != null) {
                  await _services.updateTechnicianSettings(
                    widget.id,
                    {
                      'chargePerHour': chargePerHour,
                    },
                    context,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Charge per hour set successfully"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pushNamed(context, 'technicianProfile');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Invalid charge per hour"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              width: ResponsiveDim.screenWidth,
            ),
          ],
        ),
      ),
    );
  }
}

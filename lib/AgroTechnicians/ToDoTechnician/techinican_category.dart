import 'package:flutter/material.dart';
import 'package:hatbazarsample/AgroTechnicians/ToDoTechnician/setting_services.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';

class SetTechnicianCategoryPage extends StatefulWidget {
  final int id;

  const SetTechnicianCategoryPage({Key? key, required this.id}) : super(key: key);

  @override
  _SetTechnicianCategoryPageState createState() => _SetTechnicianCategoryPageState();
}

class _SetTechnicianCategoryPageState extends State<SetTechnicianCategoryPage> {
  final TechnicianSettingServices _services =new TechnicianSettingServices();
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Technician Category", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'technicianProfile');
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select your technician category",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: "JTA",
                  child: Text("JTA"),
                ),
                DropdownMenuItem(
                  value: "Veterinary Doctor",
                  child: Text("Veterinary Doctor"),
                ),
                DropdownMenuItem(
                  value: "Soil Expert",
                  child: Text("Soil Expert"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              hint: Text("Select Category"),
              value: _selectedCategory,
            ),
            SizedBox(height: 16),
            CustomButton(
              buttonText: "Save",
              onPressed: () async {
                if (_selectedCategory != null) {
                  await _services.updateTechnicianSettings(
                    widget.id,
                    {
                      "category": _selectedCategory
                    },
                    context,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Category set successfully"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pushNamed(context, 'technicianProfile');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please select a category"),
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

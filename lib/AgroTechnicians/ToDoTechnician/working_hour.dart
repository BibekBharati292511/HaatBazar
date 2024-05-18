import 'package:flutter/material.dart';
import 'package:hatbazarsample/AgroTechnicians/ToDoTechnician/setting_services.dart';
import 'package:intl/intl.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';

class SetWorkingHoursPage extends StatefulWidget {
  final int id;

  const SetWorkingHoursPage({Key? key, required this.id}) : super(key: key);

  @override
  _SetWorkingHoursPageState createState() => _SetWorkingHoursPageState();
}

class _SetWorkingHoursPageState extends State<SetWorkingHoursPage> {
  final TechnicianSettingServices _services =new TechnicianSettingServices();
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Working Hours", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Go back to the previous screen
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
              "Set your working hours",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    buttonText: startTime != null
                        ? "Start Time: ${startTime!.format(context)}"
                        : "Select Start Time",
                    onPressed: () => _selectTime(context, true),
                    width: ResponsiveDim.screenWidth,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    buttonText: endTime != null
                        ? "End Time: ${endTime!.format(context)}"
                        : "Select End Time",
                    onPressed: () => _selectTime(context, false),
                    width: ResponsiveDim.screenWidth,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            CustomButton(
              buttonText: "Save Working Hours",
              onPressed: () async {
                String formatTimeOfDay(TimeOfDay time) {

                  final hour = (time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod).toString().padLeft(2, '0');
                  final minute = time.minute.toString().padLeft(2, '0');
                  final period = time.period == DayPeriod.am ? 'AM' : 'PM';

                  return '$hour:$minute $period';
                }
                final formattedStartTime = formatTimeOfDay(startTime!); // "11:22 PM"
                final formattedEndTime = formatTimeOfDay(endTime!);
                if (startTime != null && endTime != null) {
                  await _services.updateTechnicianSettings(
                    widget.id,
                    {
                      "startTime": formattedStartTime,
                      "endTime": formattedEndTime,
                    },
                    context,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Working hours set successfully"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pushNamed(context, 'technicianProfile');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please select start and end times"),
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

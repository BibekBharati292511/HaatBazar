import 'package:flutter/material.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'models.dart';

class AllScheduledTasksPage extends StatelessWidget {
  final List<Schedule> schedules;

  const AllScheduledTasksPage({Key? key, required this.schedules}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Scheduled Tasks",style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: schedules.length,
          itemBuilder: (context, index) {
            final schedule = schedules[index];
            return _buildScheduleCard(schedule, index);
          },
        ),
      ),
    );
  }

  Widget _buildScheduleCard(Schedule schedule, int index) {
    Color cardColor = index % 2 == 0 ? Colors.white : Colors.grey[200]!;

    return Card(
      elevation: 4,
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.event, color: Colors.green),
        title: Text(schedule.title),
        subtitle: Text("Location: ${schedule.location}"),
        trailing: Text(
          schedule.status,
          style: TextStyle(
            color: schedule.status == "In Progress" ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }
}

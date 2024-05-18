import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:http/http.dart' as http;

class Vegetable {
  final String name;
  final String unit;
  final int minimum;
  final int maximum;
  final int average;

  Vegetable({
    required this.name,
    required this.unit,
    required this.minimum,
    required this.maximum,
    required this.average,
  });

  factory Vegetable.fromJson(Map<String, dynamic> json) {
    return Vegetable(
      name: json['Commodity'],
      unit: json['unit'],
      minimum: json['minimum'],
      maximum: json['maximum'],
      average: json['average'],
    );
  }
}

class VegetableService {
  Future<List<Vegetable>> fetchVegetableData() async {
    final response = await http.get(Uri.parse('${serverBaseUrl}fetchVegetableData'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      final List<Vegetable> vegetables = responseData.map((item) {
        return Vegetable.fromJson(item);
      }).toList();
      return vegetables;
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}

class VegetableTable extends StatelessWidget {
  final List<Vegetable> vegetables;

  VegetableTable({required this.vegetables});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20,
          dataTextStyle: TextStyle(fontSize: 15,fontFamily: "poppins"),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // Add border radius for a nicer look
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          headingRowColor: MaterialStateProperty.all<Color>(Colors.black12),
          headingTextStyle: TextStyle(fontSize: 18, color: Colors.black),
          columns: [
            DataColumn(label: Text('Commodities', style: TextStyle(color: Colors.black))),
            DataColumn(label: Text('Average', style: TextStyle(color: Colors.black))),
            DataColumn(label: Text('Unit', style: TextStyle(color: Colors.black))),
            DataColumn(label: Text('Minimum', style: TextStyle(color: Colors.black))),
            DataColumn(label: Text('Maximum', style: TextStyle(color: Colors.black))),
          ],
          rows: vegetables.asMap().entries.map((entry) {
            final int index = entry.key;
            final Vegetable vegetable = entry.value;
            final bool isEven = index.isEven;
            final Color rowColor = isEven ? Colors.blue.shade50 : Colors.pink.shade50;

            return DataRow(
              color: MaterialStateProperty.all<Color>(rowColor),
              cells: [
                DataCell(
                  Text(vegetable.name)),
                DataCell(
                  Center(child: Text(vegetable.average.toString())),
                ),
                DataCell(
                  Center(child: Text(vegetable.unit)),
                ),
                DataCell(
                  Center(child: Text(vegetable.minimum.toString())),
                ),
                DataCell(
                  Center(child: Text(vegetable.maximum.toString())),
                ),
              ],
            );
          }).toList(),
        ),

      ),
    );
  }
}

class VegetableScreen extends StatefulWidget {
  @override
  _VegetableScreenState createState() => _VegetableScreenState();
}

class _VegetableScreenState extends State<VegetableScreen> {
  final VegetableService _vegetableService = VegetableService();
  late Future<List<Vegetable>> _vegetables;

  @override
  void initState() {
    super.initState();
    _vegetables = _vegetableService.fetchVegetableData();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String todayDate = '${now.year}-${now.month}-${now.day}';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: Text('Vegetable Data ($todayDate)',style: TextStyle(color: Colors.white),),backgroundColor: AppColors.primaryColor,),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder<List<Vegetable>>(
          future: _vegetables,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print("hellop");
              print(snapshot.error);
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              print("hi");
            //  print(VegetableTable(vegetables: snapshot.data??[]));
              return VegetableTable(vegetables: snapshot.data ?? []);
            }
          },
        ),
      ),
    );
  }
}

class DailyAgroPrice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VegetableScreen();
  }
}

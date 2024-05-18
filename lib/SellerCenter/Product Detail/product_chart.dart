import 'package:flutter/material.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

import '../../Utilities/ResponsiveDim.dart';
import '../../Utilities/colors.dart';
import 'package:hatbazarsample/Widgets/bigText.dart';

class ProductChart extends StatefulWidget {
  final String topic;
  final int? id;

  ProductChart({Key? key, required this.topic, this.id}) : super(key: key);

  @override
  State<ProductChart> createState() => _ProductChartState();
}

class _ProductChartState extends State<ProductChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Container(
        color: AppColors.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ChartWidget(),
              SizedBox(height: ResponsiveDim.height10,),
              BigText(text: widget.topic)
            ],
          ),
        ),
      ),
    );
  }
}

class ChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return chartToRun(); // Utilize the provided chartToRun function
  }

  Widget chartToRun() {
    List<charts.Series<dynamic, String>> seriesList = [
      charts.Series<dynamic, String>(
        id: 'Sales',
        domainFn: (dynamic sales, _) => sales['month'],
        measureFn: (dynamic sales, _) => sales['sales'],
        data: [
          {'month': 'Jan', 'sales': 20},
          {'month': 'Feb', 'sales': 25},
          {'month': 'Mar', 'sales': 30},
          {'month': 'Apr', 'sales': 35},
          {'month': 'May', 'sales': 40},
          {'month': 'Jun', 'sales': 20},
        ],
      ),
    ];

    var barChart = charts.BarChart(
      seriesList,
      vertical: false,
      barGroupingType: charts.BarGroupingType.grouped,
    );

    return SizedBox(
      height: 300,
      child: barChart,
    );
  }
}

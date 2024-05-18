import 'package:flutter/material.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:hatbazarsample/AgroTechnicians/revenue_model.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:intl/intl.dart';
import 'revenue_service.dart';

class RevenueModel {
  final RevenueService _revenueService;

  RevenueModel(this._revenueService);

  double totalEarnings = 0.0;
  List<Revenue> revenueData = [];

  Future<void> fetchTotalRevenue(String token) async {
    try {
      totalEarnings = await _revenueService.getTotalRevenueForUser(token);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> fetchRevenueByTimePeriod(String token, {int days = 7}) async {
    try {
      if (days == 15) {
        revenueData = await _revenueService.findRevenueByTokenAndLast15Days(token);
      } else if (days == 30) {
        revenueData = await _revenueService.findRevenueByTokenAndLastMonth(token);
      } else {
        revenueData = await _revenueService.findRevenueByTokenAndLastWeek(token);
      }
    } catch (e) {
      // Handle error
    }
  }
}

class RevenuePage extends StatefulWidget {
  late final String token;
   RevenuePage({super.key,required this.token});
  @override
  _RevenuePageState createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
  String _selectedTimePeriod = 'Last Week';
  late RevenueModel _revenueModel;

  @override
  void initState() {
    super.initState();
    _revenueModel = RevenueModel(RevenueService());
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await _revenueModel.fetchTotalRevenue(widget.token);
      await _revenueModel.fetchRevenueByTimePeriod(widget.token);
      setState(() {});
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Revenue', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.attach_money, color: Colors.red),
                title: Text('Total Earnings'),
                subtitle: Text('Rs ${_revenueModel.totalEarnings.toStringAsFixed(2)}'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => _changeTimePeriod('Last Week'),
                  child: Text('Last Week', style: TextStyle(color: _selectedTimePeriod == 'Last Week' ? Colors.green : Colors.grey)),
                ),
                TextButton(
                  onPressed: () => _changeTimePeriod('15 Days'),
                  child: Text('15 Days', style: TextStyle(color: _selectedTimePeriod == '15 Days' ? Colors.green : Colors.grey)),
                ),
                TextButton(
                  onPressed: () => _changeTimePeriod('Month'),
                  child: Text('Month', style: TextStyle(color: _selectedTimePeriod == 'Month' ? Colors.green : Colors.grey)),
                ),
              ],
            ),
          ),
          Expanded(
            child: _revenueModel.revenueData.isNotEmpty
                ? ChartWidget(revenueData: _revenueModel.revenueData, selectedTimePeriod: _selectedTimePeriod)
                : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  void _changeTimePeriod(String selectedPeriod) async {
    setState(() {
      _selectedTimePeriod = selectedPeriod;
    });
    await _fetchDataWithSelectedPeriod(selectedPeriod);
  }

  Future<void> _fetchDataWithSelectedPeriod(String selectedPeriod) async {
    try {
      switch (selectedPeriod) {
        case 'Last Week':
          await _revenueModel.fetchRevenueByTimePeriod(widget.token);
          break;
        case '15 Days':
          await _revenueModel.fetchRevenueByTimePeriod(widget.token, days: 15);
          break;
        case 'Month':
          await _revenueModel.fetchRevenueByTimePeriod(widget.token, days: 30);
          break;
        default:
          await _revenueModel.fetchRevenueByTimePeriod(widget.token);
      }
      setState(() {});
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
}

class ChartWidget extends StatelessWidget {
  final List<Revenue> revenueData;
  final String selectedTimePeriod;

  ChartWidget({required this.revenueData, required this.selectedTimePeriod});

  @override
  Widget build(BuildContext context) {
    return chartToRun();
  }

  Widget chartToRun() {
    List<charts.Series<Revenue, String>> seriesList = [
      charts.Series<Revenue, String>(
        id: 'Revenue',
        domainFn: (Revenue revenue, _) => DateFormat.yMMMd().format(revenue.createdDate),
        measureFn: (Revenue revenue, _) => revenue.amount,
        data: revenueData,
        colorFn: (_, __) => _chooseBarColor(),
      ),
    ];

    var barChart = charts.BarChart(
      seriesList,
      animate: true,
      vertical: true,
      barGroupingType: charts.BarGroupingType.grouped,
      behaviors: [charts.SeriesLegend()],
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        height: 300,
        child: barChart,
      ),
    );
  }

  charts.Color _chooseBarColor() {
    switch (selectedTimePeriod) {
      case 'Last Week':
        return charts.MaterialPalette.blue.shadeDefault;
      case '15 Days':
        return charts.MaterialPalette.red.shadeDefault;
      case 'Month':
        return charts.MaterialPalette.green.shadeDefault;
      default:
        return charts.MaterialPalette.blue.shadeDefault;
    }
  }
}

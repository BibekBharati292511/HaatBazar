import 'package:flutter/material.dart';
import 'package:hatbazarsample/Filter_And_Search/product_filter_model.dart';

class FilterWidget extends StatefulWidget {
  final Function(ProductFilterOptions) onApply; // Callback to apply the filter
  final ProductFilterOptions initialOptions; // Optional initial filter options

  FilterWidget({required this.onApply, required this.initialOptions});

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}


class _FilterWidgetState extends State<FilterWidget> {
  late ProductFilterOptions _filterOptions; // Local variable for filter options

  @override
  void initState() {
    super.initState();
    _filterOptions = widget.initialOptions; // Initialize with the passed options
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Filter Options", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          // Input for Harvested Season
          TextField(
            decoration: InputDecoration(labelText: "Harvested Season"),
            onChanged: (value) {
              _filterOptions.harvestedSeason = value;
            },
          ),

          // Input for Price Range
          Text("Price Range"),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: "Min Price"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _filterOptions.minPrice = double.tryParse(value);
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: "Max Price"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _filterOptions.maxPrice = double.tryParse(value);
                  },
                ),
              ),
            ],
          ),

          // Input for Available Quantity Range
          Text("Available Quantity Range"),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: "Min Quantity"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _filterOptions.minQty = double.tryParse(value);
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: "Max Quantity"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _filterOptions.maxQty = double.tryParse(value);
                  },
                ),
              ),
            ],
          ),

          // Dropdown for Category
          Text("Category"),
          DropdownButton<String>(
            value: _filterOptions.category,
            items: [
              DropdownMenuItem(value: "1", child: Text("Category 1")),
              DropdownMenuItem(value: "2", child: Text("Category 2")),
              // Add additional categories
            ],
            onChanged: (value) {
              _filterOptions.category = value;
            },
          ),

          // Dropdown for Sub-category
          Text("Sub-category"),
          DropdownButton<String>(
            value: _filterOptions.subCategory,
            items: [
              DropdownMenuItem(value: "1", child: Text("Sub-category 1")),
              DropdownMenuItem(value: "2", child: Text("Sub-category 2")),
              // Add additional sub-categories
            ],
            onChanged: (value) {
              _filterOptions.subCategory = value;
            },
          ),

          // Apply Button
          ElevatedButton(
            onPressed: () {
              widget.onApply(_filterOptions); // Apply the filter
              Navigator.pop(context); // Close the dialog or bottom sheet
            },
            child: Text("Apply Filter"),
          ),
        ],
      ),
    );
  }
}

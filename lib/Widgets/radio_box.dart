import 'package:flutter/material.dart';

class RadioBox extends StatelessWidget {
  final List<String> options;
  final String? selectedOption;
  final ValueChanged<String?>? onChanged;

  const RadioBox({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((option) {
        return ListTile(
          title: Text(option),
          leading: Radio<String>(
            value: option,
            groupValue: selectedOption,
            onChanged: onChanged,
          ),
        );
      }).toList(),
    );
  }
}

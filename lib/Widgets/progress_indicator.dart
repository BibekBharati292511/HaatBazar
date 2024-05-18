import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utilities/ResponsiveDim.dart';

class ProgressIndicators extends StatefulWidget {
  const ProgressIndicators({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.pageName,
  });

  final int currentPage;
  final int totalPages;
  final String? pageName;

  @override
  State<ProgressIndicators> createState() => _ProgressIndicatorsState();
}

class _ProgressIndicatorsState extends State<ProgressIndicators> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            LinearProgressIndicator(
              value: widget.currentPage / widget.totalPages,
              backgroundColor: Colors.grey,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${widget.currentPage}/${widget.totalPages}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        if (widget.pageName != null) SizedBox(height: ResponsiveDim.height10),
        if (widget.pageName != null)
          Text(
            widget.pageName!,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}

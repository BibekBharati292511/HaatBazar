import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressIndicators extends StatefulWidget {
  const ProgressIndicators({super.key, required this.currentPage, required this.totalPages});
  final int currentPage;
  final int totalPages;

  @override
  State<ProgressIndicators> createState() => _ProgressIndicatorsState();
}

class _ProgressIndicatorsState extends State<ProgressIndicators> {
  @override
  Widget build(BuildContext context) {
    return Stack(
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
    );
  }
}

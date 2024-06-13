import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String dataType;
  final num percentage;
  final Color textColor;

  const InfoCard({
    super.key,
    required this.dataType,
    required this.percentage,
    this.textColor = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-8.0, -8.0),
            blurRadius: 16.0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(8.0, 8.0),
            blurRadius: 16.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dataType,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 24.0,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

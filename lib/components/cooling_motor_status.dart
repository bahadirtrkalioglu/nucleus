import 'package:flutter/material.dart';

class CoolingMotorStatusCard extends StatelessWidget {
  final bool isWorking;

  const CoolingMotorStatusCard({super.key, required this.isWorking});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16.0),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Soğutma Motoru Durumu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              isWorking ? 'Çalışıyor' : 'Çalışmıyor',
              style: TextStyle(
                fontSize: 24.0,
                color: isWorking ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

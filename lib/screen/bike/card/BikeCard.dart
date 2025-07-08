import 'package:flutter/material.dart';

class Bikecard extends StatelessWidget {
  final String name;
  final String passcode;

  const Bikecard({
    super.key,
    required this.name,
    required this.passcode,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("password: $passcode", style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

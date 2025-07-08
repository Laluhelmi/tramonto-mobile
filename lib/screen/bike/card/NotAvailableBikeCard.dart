import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class NotAvailableBikeCard extends StatelessWidget {
  final String name;
  final String namaSepeda;
  final DateTime startTime;
  final DateTime endTime;
  final String statusLabel;

  const NotAvailableBikeCard({
    super.key,
    required this.name,
    required this.namaSepeda,
    required this.startTime,
    required this.endTime,
    required this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {

    final wita          = tz.getLocation('Asia/Makassar');
    final startTimeWita = tz.TZDateTime.from(startTime, wita);
    final endTimeWita   = tz.TZDateTime.from(endTime, wita);

    final dateFormat = DateFormat('d MMM yyyy, HH.mm');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(namaSepeda,style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("disewa oleh $name", style: const TextStyle(fontSize: 16, color: Colors.black)),
            const SizedBox(height: 4),
            Text(
              '${dateFormat.format(startTimeWita)} – ${dateFormat.format(endTimeWita)}',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusLabel == "waktu habis dan belum dikembalikan"
                    ? Colors.red.shade400
                    : Colors.green.shade400, // ganti warna sesuai logika kamu
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                statusLabel.isEmpty ? "Status tidak diketahui" : statusLabel,
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

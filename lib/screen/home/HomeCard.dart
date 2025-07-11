import 'package:flutter/material.dart';
import 'package:tramontonbike/model/RentTransac.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

class HomeCard extends StatelessWidget {
  final Renttransac transaction;
  final VoidCallback onPressed;

  const HomeCard({
    super.key,
    required this.transaction,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final wita = tz.getLocation('Asia/Makassar');
    final startTimeWita = tz.TZDateTime.from(transaction.startTime, wita);
    final endTimeWita = tz.TZDateTime.from(transaction.endTime, wita);
    final dateFormat = DateFormat('d MMM yyyy, HH.mm');
    final harga = NumberFormat.decimalPattern(
      'id_ID',
    ).format(transaction.price);

    // transaction.bikes
    final bikes = transaction.bikes;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${dateFormat.format(startTimeWita)} - ${dateFormat.format(endTimeWita)}",
                style: const TextStyle(fontSize: 11, color: Colors.black),
              ),
              const SizedBox(height: 4),

              ListView.builder(
                itemCount: bikes.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final sepeda = bikes[index].name;
                  final status = bikes[index].status ?? "";

                  return Row(
                    children: [
                      Expanded(
                        flex: 2, // kolom sepeda
                        child: Text(
                          sepeda,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3, // kolom status
                        child: Text(
                          status,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 4),
              Text(
                "Harga: Rp $harga",
                style: const TextStyle(fontSize: 11, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

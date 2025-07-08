import 'package:flutter/material.dart';
import 'package:tramontonbike/Remote/GuestApi.dart';
import 'package:tramontonbike/model/HomeResp.dart';
import 'package:tramontonbike/model/RentTransac.dart';
import 'package:tramontonbike/screen/home/HomeCard.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<TransactionResponse> futureTrans;

  @override
  void initState() {
    super.initState();
    futureTrans = ApiService.fetchAllTransactions();
  }

  Future<void> _refreshData() async {
    setState(() {
      futureTrans = ApiService.fetchAllTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TransactionResponse>(
      future: futureTrans,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final transactions = snapshot.data;

        // Tampilkan RefreshIndicator meskipun tidak ada data
        if (!snapshot.hasData || transactions!.data.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView(
              children: const [
                SizedBox(height: 200),
                Center(child: Text('Semua sepeda di rumah')),
              ],
            ),
          );
        }

        final formattedTotal =
            NumberFormat.decimalPattern('id_ID').format(transactions.total);

        return RefreshIndicator(
          onRefresh: _refreshData,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.data.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions.data[index];
                    return HomeCard(
                      transaction: transaction,
                      onPressed: () {
                        showGuestDetailDialog(context, transaction);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Total pemasukkan: Rp $formattedTotal",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showGuestDetailDialog(BuildContext context, Renttransac data) {
    final rentPrice = NumberFormat.decimalPattern('id_ID').format(data.price);

    showDialog(
      context: context,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: SizedBox(
            width: screenWidth * 0.9,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text("Nama Penyewa: ${data.name}"),
                  const SizedBox(height: 12),
                  Text("No Telp: ${data.phoneNumber}"),
                  const SizedBox(height: 12),
                  Text("Harga Sewa: Rp $rentPrice"),
                  const SizedBox(height: 12),
                  Text("Hotel: ${data.address}"),
                  const SizedBox(height: 12),
                  Text("Status: ${data.status}"),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Tutup",
                          style: TextStyle(color: Colors.deepPurple)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

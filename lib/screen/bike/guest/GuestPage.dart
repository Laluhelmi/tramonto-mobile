import 'package:flutter/material.dart';
import 'package:tramontonbike/Remote/GuestApi.dart';
import 'package:tramontonbike/model/Guest.dart';

class GuestPage extends StatefulWidget {
  const GuestPage({super.key});

  @override
  State<GuestPage> createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> with AutomaticKeepAliveClientMixin {
  late Future<List<Guest>> futureGuests;

  @override
  void initState() {
    super.initState();
    futureGuests = ApiService.fetchGuests();
  }

  Future<void> _refreshData() async {
    setState(() {
      futureGuests = ApiService.fetchGuests();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); 
    return FutureBuilder<List<Guest>>(
      future: futureGuests,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || (snapshot.data?.isEmpty ?? true)) {
          return const Center(child: Text('Tidak ada data'));
        }

        final guests = snapshot.data ?? [];
        

        return RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView.builder(
            physics     : const AlwaysScrollableScrollPhysics(), 
            itemCount   : guests.length,
            itemBuilder : (context, index) {
              final guest = guests[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(guest.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("HP: ${guest.phoneNumber}"),
                      Text("Alamat: ${guest.address}"),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => false; // supaya tidak rebuild saat pindah tab
}

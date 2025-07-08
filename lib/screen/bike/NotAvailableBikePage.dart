import 'package:flutter/material.dart';
import 'package:tramontonbike/Remote/GuestApi.dart';
import 'package:tramontonbike/model/NotAvailableBike.dart';
import 'package:tramontonbike/screen/bike/card/NotAvailableBikeCard.dart';

class NotAvailableBikePage extends StatefulWidget {
  const NotAvailableBikePage({super.key});

  @override
  State<NotAvailableBikePage> createState() => _NotAvailableBikePageState();
}

class _NotAvailableBikePageState extends State<NotAvailableBikePage> {

late Future<List<Notavailablebike>> futureBikes;

  @override
  void initState() {
    super.initState();
    futureBikes = ApiService.fetchNotAvailableBikes();
  }

  Future<void> _refreshData() async {
    setState(() {
      futureBikes = ApiService.fetchNotAvailableBikes();
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder<List<Notavailablebike>>(future: futureBikes, builder: (context,snapshot){

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final bikes = snapshot.data ?? [];

        if (!snapshot.hasData || (snapshot.data?.isEmpty ?? true)) {
          return const Center(child: Text('Semua sepeda di rumah'));
        }
        
        return RefreshIndicator(
          onRefresh : _refreshData,
          child     : ListView.builder(
            physics     : const AlwaysScrollableScrollPhysics(), 
            itemCount   : bikes.length,
            itemBuilder : (context, index) {
              final bike = bikes[index];
              return NotAvailableBikeCard(name          : bike.name,
                                          namaSepeda    : bike.namaSepeda, 
                                          startTime     : bike.startTime,
                                          endTime       : bike.endTime,
                                          statusLabel   : bike.statusLabel);
            },
          ),
        );
    });
  }
}
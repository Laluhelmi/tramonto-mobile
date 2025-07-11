import 'package:flutter/material.dart';
import 'package:tramontonbike/Remote/GuestApi.dart';
import 'package:tramontonbike/model/Bike.dart';
import 'package:tramontonbike/screen/bike/card/BikeCard.dart';

class AvailableBikePage extends StatefulWidget {
  const AvailableBikePage({super.key});

  @override
  State<AvailableBikePage> createState() => _AvailableBikePageState();
}

class _AvailableBikePageState extends State<AvailableBikePage> {


late Future<List<Bike>> futureBikes;

  @override
  void initState() {
    super.initState();
    futureBikes = ApiService.fetchAvailableBikes();
  }

  Future<void> _refreshData() async {
    setState(() {
      futureBikes = ApiService.fetchAvailableBikes();
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder<List<Bike>>(future: futureBikes, builder: (context,snapshot){

       if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || (snapshot.data?.isEmpty ?? true)) {
          return const Center(child: Text('Tidak ada data'));
        }

        final bikes = snapshot.data ?? [];
        
        return RefreshIndicator(
          onRefresh : _refreshData,
          child     : ListView.builder(
            physics     : const AlwaysScrollableScrollPhysics(), 
            itemCount   : bikes.length,
            itemBuilder : (context, index) {
              final bike = bikes[index];
              return Bikecard(name: bike.name, passcode: bike.passcode ?? "");
            },
          ),
        );

    });
  }
}
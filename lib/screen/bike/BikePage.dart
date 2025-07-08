
import 'package:flutter/material.dart';
import 'package:tramontonbike/screen/bike/AvailableBikePage.dart';
import 'package:tramontonbike/screen/bike/NotAvailableBikePage.dart';

class BikePage extends StatelessWidget {
  const BikePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length  : 2,
      child   : Column(
        children: [
          const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: 'Sedang disewa'),
              Tab(text: 'Tersedia')
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                Center(child: NotAvailableBikePage()),
                Center(child: AvailableBikePage())
              ],
            ),
          ),
        ],
      ),
    );
  } 
}
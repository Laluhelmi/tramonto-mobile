import 'package:flutter/material.dart';
import 'package:tramontonbike/screen/form/BikeRentalForm.dart';
import 'package:tramontonbike/screen/home/HomePage.dart';
import 'package:tramontonbike/screen/bike/guest/GuestPage.dart';
import 'package:tramontonbike/screen/bike/BikePage.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Nav Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [HomePage(), const BikePage(), const GuestPage()];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tramonto')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BikeRentalForm()),
          );
        },
        child: Icon(Icons.add),
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      // body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bike),
            label: 'Sepeda',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Tamu'),
        ],
      ),
    );
  }
}

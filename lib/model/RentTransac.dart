import 'package:tramontonbike/model/Bike.dart';

class Renttransac {
  final String name;
  final int transactionId;
  final String bookingCode;
  final DateTime startTime;
  final DateTime endTime;
  final String phoneNumber;
  final int price;
  final List<Bike> bikes;
  final String address;

  Renttransac({
    required this.name,
    required this.transactionId,
    required this.bookingCode,
    required this.startTime,
    required this.endTime,
    required this.phoneNumber,
    required this.price,
    required this.bikes,
    required this.address,
  });

  factory Renttransac.fromJson(Map<String, dynamic> json) {
    return Renttransac(
      name: json['name'],
      transactionId: json['transaction_id'],
      bookingCode: json['booking_code'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      phoneNumber: json['phone_number'],
      price: json['price'],
      bikes: (json['bikes'] as List<dynamic>)
          .map((bikeJson) => Bike.fromJson(bikeJson))
          .toList(),
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'transaction_id': transactionId,
      'booking_code': bookingCode,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'phone_number': phoneNumber,
      'price': price,
      'bikes': bikes.map((bike) => bike.toJson()).toList(),
      'address': address,
    };
  }
}

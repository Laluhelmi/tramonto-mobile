import 'package:tramontonbike/model/Bike.dart';
import 'package:tramontonbike/model/BookingRequest.dart';
import 'package:tramontonbike/model/Guest.dart';
import 'package:http/http.dart' as http;
import 'package:tramontonbike/model/HomeResp.dart';
import 'dart:convert';
import 'package:tramontonbike/model/NotAvailableBike.dart';

class ApiService {
  static Future<List<Guest>> fetchGuests() async {
    final response = await http.get(
      Uri.parse('https://bike-production-675e.up.railway.app/guests'),
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Guest.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  static Future<List<Notavailablebike>> fetchNotAvailableBikes() async {
    final response = await http.get(
      Uri.parse(
        'https://bike-production-675e.up.railway.app/not-available-bikes',
      ),
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Notavailablebike.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  static Future<List<Bike>> fetchAvailableBikes() async {
    final response = await http.get(
      Uri.parse('https://bike-production-675e.up.railway.app/available-bikes'),
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Bike.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  static Future<TransactionResponse> fetchAllTransactions() async {
    final response = await http.get(
      Uri.parse('https://bike-production-675e.up.railway.app/'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return TransactionResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  static Future<String> submitBooking(BookingRequest request) async {

    final uri  = Uri.parse('https://bike-production-675e.up.railway.app/new-transaction');
    final body = {
      "name"            : request.name,
      "address"         : request.address,
      "phoneNumber"     : request.phoneNumber,
      "price"           : request.price,
      "startTime"       : request.startTime,
      "endTime"         : request.endTime,
      "bikeIds"         : request.bikeIds,
    };

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return "✅ Booking berhasil!";
    } else {
      throw Exception("Gagal: ${response.statusCode}");
    }
  }
}

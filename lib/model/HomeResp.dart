import 'RentTransac.dart';

class TransactionResponse {
  final List<Renttransac> data;
  final int total;

  TransactionResponse({
    required this.data,
    required this.total,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      data: List<Renttransac>.from(
        json['data'].map((x) => Renttransac.fromJson(x)),
      ),
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data'  : data.map((x) => x.toJson()).toList(),
      'total' : total,
    };
  }
}

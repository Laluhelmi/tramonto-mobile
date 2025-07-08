

class Guest {
  final int id;
  final String name;
  final String address;
  final String phoneNumber;

  Guest({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
  });

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(id: json['id'], name:  json['name'], address:  json['address'], phoneNumber:  json['phone_number']);
  }
}

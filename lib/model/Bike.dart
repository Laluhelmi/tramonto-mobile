class Bike {
  final int id;
  final String name;
  final String? passcode;
  final String? status;

  Bike({
    required this.id,
    required this.name,
    this.passcode,
    this.status,
  });

  factory Bike.fromJson(Map<String, dynamic> json) {
    return Bike(
      id      : json['id'] as int,
      name    : json['name'] ?? '',
      passcode: json['passcode'] ?? '', // aman jika null
      status  : json['status'] ?? '',     // aman jika null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id'      : id,
      'name'    : name,
      'passcode': passcode,
      'status'  : status,
    };
  }
}

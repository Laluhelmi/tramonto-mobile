class Bike {
  final int id;
  final String name;
  final String passcode;

  Bike({
    required this.id,
    required this.name,
    required this.passcode,
  });

  factory Bike.fromJson(Map<String, dynamic> json) {
    return Bike(
      id: json['id'],
      name: json['name'],
      passcode: json['passcode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'passcode': passcode,
    };
  }
}

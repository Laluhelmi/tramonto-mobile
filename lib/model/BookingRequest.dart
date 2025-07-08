class BookingRequest {
  final String    name;
  final String    address;
  final String    phoneNumber;
  final int       price;
  final int       duration;
  final List<int> bikeIds;

  BookingRequest({
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.price,
    required this.duration,
    required this.bikeIds,
  });

  factory BookingRequest.fromJson(Map<String, dynamic> json) {
    return BookingRequest(
      name        : json['name'],
      address     : json['address'],
      phoneNumber : json['phoneNumber'],
      price       : json['price'],
      duration    : json['duration'],
      bikeIds     : List<int>.from(json['bikeIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name'        : name,
      'address'     : address,
      'phoneNumber' : phoneNumber,
      'price'       : price,
      'duration'    : duration,
      'bikeIds'     : bikeIds,
    };
  }
}

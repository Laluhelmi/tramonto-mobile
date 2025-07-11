class BookingRequest {
  final String    name;
  final String    address;
  final String    phoneNumber;
  final int       price;
  final List<int> bikeIds;
  final String    startTime;
  final String    endTime;

  BookingRequest({
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.price,
    required this.bikeIds,
    required this.startTime,
    required this.endTime,
  });

  factory BookingRequest.fromJson(Map<String, dynamic> json) {
    return BookingRequest(
      name        : json['name'],
      address     : json['address'],
      phoneNumber : json['phoneNumber'],
      price       : json['price'],
      bikeIds     : List<int>.from(json['bikeIds']),
      startTime   : json['startTime'],
      endTime     : json['endTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name'        : name,
      'address'     : address,
      'phoneNumber' : phoneNumber,
      'price'       : price,
      'bikeIds'     : bikeIds,
      'startTime'   : startTime,
      'endTime'     : endTime,
    };
  }
}

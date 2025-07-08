class Notavailablebike {
  final int bikeId;
  final String namaSepeda;
  final int transactionId;
  final DateTime startTime;
  final DateTime endTime;
  final String name;
  final String statusLabel;

  Notavailablebike({
    required this.bikeId,
    required this.namaSepeda,
    required this.transactionId,
    required this.startTime,
    required this.endTime,
    required this.name,
    required this.statusLabel,
  });

  factory Notavailablebike.fromJson(Map<String, dynamic> json) {
    return Notavailablebike(
      bikeId          : json['bike_id'],
      namaSepeda      : json['nama_sepeda'],
      transactionId   : json['transaction_id'],
      startTime       : DateTime.parse(json['start_time']),
      endTime         : DateTime.parse(json['end_time']),
      name            : json['name'],
      statusLabel     : json['status_label'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bike_id'           : bikeId,
      'nama_sepeda'       : namaSepeda,
      'transaction_id'    : transactionId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'name': name,
      'status_label': statusLabel,
    };
  }
}

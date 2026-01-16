class Flight {
  final String id;
  final String airline;
  final String flightNumber;
  final String origin;
  final String destination;
  final String date;
  final double price;

  Flight({
    required this.id,
    required this.airline,
    required this.flightNumber,
    required this.origin,
    required this.destination,
    required this.date,
    required this.price,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      id: json['id'] as String,
      airline: json['airline'] as String,
      flightNumber: json['flightNumber'] as String,
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      date: json['date'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}


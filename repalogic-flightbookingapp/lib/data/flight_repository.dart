import '../model/flight_model.dart';

class FlightRepository {
  final List<Map<String, dynamic>> _mockFlights = [
    {
      "id": "F1",
      "airline": "IndiGo",
      "flightNumber": "6E-2134",
      "origin": "Delhi",
      "destination": "Mumbai",
      "date": "2026-02-10",
      "price": 5200.0
    },
    {
      "id": "F2",
      "airline": "Air India",
      "flightNumber": "AI-864",
      "origin": "Delhi",
      "destination": "Bangalore",
      "date": "2026-02-10",
      "price": 6100.0
    },
    {
      "id": "F3",
      "airline": "Vistara",
      "flightNumber": "UK-987",
      "origin": "Kochi",
      "destination": "Bangalore",
      "date": "2026-02-10",
      "price": 7200.0
    },
    {
      "id": "F4",
      "airline": "Akasa Air",
      "flightNumber": "QP-552",
      "origin": "Kolkatta",
      "destination": "Bangalore",
      "date": "2026-04-10",
      "price": 8100.0
    },
    {
      "id": "F5",
      "airline": "SpiceJet",
      "flightNumber": "SG-431",
      "origin": "Delhi",
      "destination": "Mumbai",
      "date": "2026-02-10",
      "price": 9200.0
    },
    {
      "id": "F6",
      "airline": "IndiGo",
      "flightNumber": "6E-7721",
      "origin": "Delhi",
      "destination": "Bangalore",
      "date": "2026-02-10",
      "price": 7100.0
    },
  ];


  Future<List<Flight>> searchFlights(
      String origin,
      String destination,
      String date,
      ) async {
    await Future.delayed(const Duration(seconds: 1));

    return _mockFlights
        .where((f) =>
    f['origin'] == origin &&
        f['destination'] == destination &&
        f['date'] == date)
        .map((e) => Flight.fromJson(e))
        .toList();
  }
}

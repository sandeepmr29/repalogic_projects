import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/flight_repository.dart';
import '../model/flight_model.dart';

final flightRepositoryProvider =
Provider((ref) => FlightRepository());

final flightViewModelProvider =
StateNotifierProvider<FlightViewModel, AsyncValue<List<Flight>>>(
      (ref) => FlightViewModel(ref.read(flightRepositoryProvider)),
);

class FlightViewModel extends StateNotifier<AsyncValue<List<Flight>>> {
  final FlightRepository _repo;

  FlightViewModel(this._repo) : super(const AsyncValue.data([]));

  Future<void> searchFlights(
      String origin,
      String destination,
      String date,
      ) async {
    state = const AsyncValue.loading();

    try {
      final flights = await _repo.searchFlights(
        origin,
        destination,
        date,
      );
      state = AsyncValue.data(flights);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

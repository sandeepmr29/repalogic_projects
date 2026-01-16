import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../viewmodel/flight_view_model.dart';
const Color primaryRed = Color(0xFFBF2424);
const Color lightRed = Color(0xFFFDEAEA);
class FlightListView extends ConsumerWidget {
  const FlightListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(flightViewModelProvider);
    final translation = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: lightRed,
      appBar: AppBar(
        title:  Text(translation.translate("available_flights_text")),
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: state.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: primaryRed),
        ),

        error: (e, _) => Center(
          child: Text(
            'Error: $e',
            style: const TextStyle(color: primaryRed),
          ),
        ),

        data: (flights) => flights.isEmpty
            ? Center(
          child: Text(
            translation.translate("no_flights_text"),
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: flights.length,
          itemBuilder: (_, i) {
            final flight = flights[i];

            return
              Card(
                elevation: 6,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// Airline Name + Flight Number
                      Row(
                        children: [
                          const Icon(Icons.airplanemode_active,
                              size: 18, color: primaryRed),
                          const SizedBox(width: 6),
                          Text(
                            '${flight.airline} • ${flight.flightNumber}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// Route
                      Row(
                        children: [
                          Icon(Icons.flight_takeoff,
                              color: primaryRed, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            flight.origin,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(Icons.arrow_forward),
                          ),
                          Text(
                            flight.destination,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      /// Date
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 16, color: Colors.black54),
                          const SizedBox(width: 6),
                          Text(
                            flight.date,
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// Price + Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹${flight.price}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryRed,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: primaryRed,
                                  content: Text(
                                    'Flight ${flight.id} booked successfully!',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryRed,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              translation.translate("book_text"),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );

          },
        ),
      ),
    );
  }
}


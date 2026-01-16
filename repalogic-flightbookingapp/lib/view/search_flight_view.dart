import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../viewmodel/flight_view_model.dart';
import 'flight_list_view.dart';
const Color primaryRed = Color(0xFFBF2424);
const Color lightRed = Color(0xFFFDEAEA);
class SearchFlightView extends ConsumerWidget {
  SearchFlightView({super.key});

  final _formKey = GlobalKey<FormState>();

  final originInputController = TextEditingController();
  final destInputController = TextEditingController();
  final dateInputController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translation = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: lightRed,
      appBar: AppBar(
        title: Text(translation.translate("search_flight_text")),
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// Heading
                  Text(
                    translation.translate("find_your_flight_text"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryRed,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    translation.translate("search_compare_text"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Origin
                  TextFormField(
                    controller: originInputController,
                    decoration: _inputDecoration(
                      label: translation.translate("origin_text"),
                      icon: Icons.flight_takeoff,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return translation.translate("origin_required_text");
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  /// Destination
                  TextFormField(
                    controller: destInputController,
                    decoration: _inputDecoration(
                      label: translation.translate("destination_text"),
                      icon: Icons.flight_land,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return translation.translate("destination_required_text");
                      }
                      if (value.trim() ==
                          originInputController.text.trim()) {
                        return translation.translate(
                            "origin_destination_same_text");
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  /// Date Picker
                  TextFormField(
                    controller: dateInputController,
                    readOnly: true,
                    decoration: _inputDecoration(
                      label:
                      translation.translate("departure_date_text"),
                      icon: Icons.calendar_today,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return translation
                            .translate("departure_date_required_text");
                      }
                      return null;
                    },
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate:
                        DateTime.now().add(const Duration(days: 365)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: primaryRed,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null) {
                        dateInputController.text = pickedDate
                            .toIso8601String()
                            .split('T')
                            .first;
                      }
                    },
                  ),

                  const SizedBox(height: 30),

                  /// Search Button
                  ElevatedButton.icon(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;

                      ref
                          .read(flightViewModelProvider.notifier)
                          .searchFlights(
                        originInputController.text.trim(),
                        destInputController.text.trim(),
                        dateInputController.text.trim(),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FlightListView(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.search, color: Colors.white),
                    label: Text(
                      translation.translate("search_flight_text"),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRed,
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryRed),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryRed, width: 2),
      ),
    );
  }
}



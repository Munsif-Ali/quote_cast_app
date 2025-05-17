import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_cast_app/screens/home/affirmation_widget.dart';
import 'package:quote_cast_app/screens/home/city_selection_dialog.dart';
import 'package:quote_cast_app/screens/home/quote_widget.dart';
import 'package:quote_cast_app/screens/home/weather_widget.dart';

class WeatherAndQuotes extends ConsumerWidget {
  const WeatherAndQuotes({super.key});

  @override
  Widget build(context, ref) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Row(
          children: [
            Expanded(
              child: const Text(
                'Select a city to get the weather',
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const CitySelectionDialog(),
                );
              },
              child: const Text('Select a City'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const WeatherWidget(),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: const Text(
                'Quote of the Day',
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () {
                ref.invalidate(quoteFutureProvider);
              },
              child: const Text('Refresh Quote'),
            ),
          ],
        ),
        const QuoteWidget(),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: const Text(
                'Affirmation',
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () {
                ref.invalidate(affirmationFutureProvider);
              },
              child: const Text('Refresh Affirmation'),
            ),
          ],
        ),
        const AffirmationWidget(),
        const SizedBox(height: 20),
      ],
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_cast_app/core/constants/string_const.dart';
import 'package:quote_cast_app/data/models/quote_model.dart';
import 'package:quote_cast_app/data/models/weather_model.dart';
import 'package:quote_cast_app/screens/home/city_selection_dialog.dart';
import 'package:quote_cast_app/screens/home/home_drawer.dart';
import 'package:quote_cast_app/screens/home/quote_widget.dart';
import 'package:quote_cast_app/screens/home/weather_widget.dart';

import '../../data/services/api_service.dart';
import '../../providers/selected_city_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView(
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
      ),
    );
  }
}

final weatherFutureProvider =
    FutureProvider.family<WeatherModel, String?>((ref, selectedCity) async {
  log('Selected city: $selectedCity');
  if (selectedCity == null) {
    throw Exception('No city selected');
  }
  final apiService = ref.read(apiServiceProvider);
  final weather = await apiService.getWeather(selectedCity);
  return weather;
});

class AffirmationWidget extends ConsumerWidget {
  const AffirmationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final affirmationAsync = ref.watch(affirmationFutureProvider);
    return affirmationAsync.when(
      data: (affirmation) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            affirmation,
            style: const TextStyle(fontSize: 18),
          ),
        );
      },
      error: (error, st) {
        return Center(child: Text('Error: $error'));
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

final affirmationFutureProvider = FutureProvider<String>((ref) async {
  final apiService = ref.read(apiServiceProvider);

  final selectedCity = ref.watch(selelctedCityProvider);

  if (selectedCity == null) {
    return 'No city selected';
  }

  final weatherAsync = ref.watch(weatherFutureProvider(selectedCity));

  final quoteAsync = ref.watch(quoteFutureProvider);

  if (weatherAsync.isLoading || quoteAsync.isLoading) {
    return 'Loading...';
  }

  if (weatherAsync.hasError || quoteAsync.hasError) {
    if (weatherAsync.hasError) {
      return 'Error: ${weatherAsync.error}';
    }
    return 'Error: ${weatherAsync.error}';
  }

  final weather = weatherAsync.value;
  final quote = quoteAsync.value;

  if (weather == null || quote == null) {
    return 'Error: No data available';
  }

  final affirmation = await apiService.getAffirmation(weather, quote);
  return affirmation;
});

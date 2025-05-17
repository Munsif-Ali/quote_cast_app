import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_cast_app/screens/home/home_screen.dart';
import 'package:quote_cast_app/screens/home/quote_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/services/api_service.dart';
import '../../providers/selected_city_provider.dart';

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
      loading: () => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Text(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        ),
      ),
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

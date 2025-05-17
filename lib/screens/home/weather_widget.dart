import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_cast_app/core/constants/string_const.dart';
import 'package:quote_cast_app/screens/home/home_screen.dart';

import '../../providers/selected_city_provider.dart';

class WeatherWidget extends ConsumerWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCity = ref.watch(selelctedCityProvider);
    final weatherAsync = ref.watch(weatherFutureProvider(selectedCity));
    return weatherAsync.when(
      data: (weather) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                getWeatherTileColor(weather.icon).withOpacity(0.5),
                getWeatherTileColor(weather.icon),
              ],
            ),
            image: DecorationImage(
              image: NetworkImage(
                StringConst.iconUrl.replaceFirst(
                  '{icon}',
                  "${weather.icon}@4x",
                ),
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weather.city,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        weather.country,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image.network(
                          StringConst.iconUrl
                              .replaceFirst('{icon}', weather.icon),
                          width: 30,
                        ),
                        Text(
                          weather.description,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    // Temperature
                    Row(
                      children: [
                        Text(
                          "${weather.temperature?.toStringAsFixed(1)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '°C',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      error: (error, st) {
        log("Error: $error", stackTrace: st);
        return Text('Error: $error');
      },
      loading: () => const CircularProgressIndicator(),
    );
  }
}

Color getWeatherTileColor(String condition) {
  switch (condition) {
    case '01d':
    case '01n':
      return Color(0xFF87CEEB);
    case '02d':
    case '02n':
      return Color(0xFFADD8E6);
    case '03d':
    case '03n':
      return Color(0xFFB0C4DE);
    case '04d':
    case '04n':
      return Color(0xFFA9A9A9);
    case '09d':
    case '09n':
      return Color(0xFF778899);
    case '10d':
    case '10n':
      return Color(0xFF4682B4);
    case '11d':
    case '11n':
      return Color(0xFF800080);
    case '13d':
    case '13n':
      return Color(0xFFFFFFFF);
    case '50d':
    case '50n':
      return Color(0xFFD3D3D3);
    default:
      return Colors.grey;
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_cast_app/data/models/weather_model.dart';
import 'package:quote_cast_app/screens/home/all_users_table.dart';
import 'package:quote_cast_app/screens/home/home_drawer.dart';
import 'package:quote_cast_app/screens/home/weather_and_quotes.dart';

import '../../data/services/api_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> _screens = [
    const WeatherAndQuotes(),
    const AllUsersTable(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: _screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Users',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
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

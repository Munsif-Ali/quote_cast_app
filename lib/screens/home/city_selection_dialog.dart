import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quote_cast_app/core/constants/string_const.dart';
import 'package:quote_cast_app/core/extensions/context_extension.dart';
import 'package:quote_cast_app/screens/home/home_screen.dart';

import '../../providers/selected_city_provider.dart';

class CitySelectionDialog extends ConsumerStatefulWidget {
  const CitySelectionDialog({super.key});

  @override
  ConsumerState<CitySelectionDialog> createState() =>
      _CitySelectionDialogState();
}

class _CitySelectionDialogState extends ConsumerState<CitySelectionDialog> {
  final cityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a City'),
      content: TextField(
        controller: cityController,
        decoration: const InputDecoration(hintText: 'Enter city name'),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final city = cityController.text.trim();
            if (city.isNotEmpty) {
              ref.read(selelctedCityProvider.notifier).state = city;
              await FlutterSecureStorage()
                  .write(key: StringConst.selectedCityKey, value: city);
              if (!context.mounted) return;
              Navigator.pop(context);
            } else {
              context.showSnackBar('Please enter a city name');
            }
          },
          child: const Text('OK'),
        ),
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

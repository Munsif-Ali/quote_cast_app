import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:quote_cast_app/core/constants/app_routes.dart';
import 'package:quote_cast_app/core/styles/app_theme.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: LoaderOverlay(
        child: MaterialApp(
          title: 'QuoteCast',
          theme: AppTheme.lightTheme,
          routes: AppRoutes.routes,
          initialRoute: AppRoutes.splash,
        ),
      ),
    );
  }
}

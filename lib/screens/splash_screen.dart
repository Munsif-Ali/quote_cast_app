import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_cast_app/core/constants/app_routes.dart';
import 'package:quote_cast_app/core/extensions/context_extension.dart';

import '../providers/user_session_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(context, ref) {
    ref.listen(userSessionProvider, (previous, next) {
      next.when(
        data: (userSession) {
          if (userSession.isLoggedIn) {
            context.navigateAndRemoveUntil(AppRoutes.home);
          } else {
            context.navigateAndRemoveUntil(AppRoutes.login);
          }
        },
        error: (error, st) {
          log('Error fetching user session: ', error: error, stackTrace: st);
          context.showSnackBar('Error fetching user session', isError: true);
          context.navigateAndRemoveUntil(AppRoutes.login);
        },
        loading: () {},
      );
    });

    return Scaffold(
      body: Center(
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Welcome to QuoteCast',
              textStyle: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
        ),
      ),
    );
  }
}

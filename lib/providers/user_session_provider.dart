import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quote_cast_app/core/constants/string_const.dart';
import 'package:quote_cast_app/data/models/user_model.dart';
import 'package:quote_cast_app/providers/auth_controller_provider.dart';
import 'package:quote_cast_app/providers/selected_city_provider.dart';

import '../data/models/user_session.dart';

final userSessionProvider = FutureProvider<UserSession>((ref) async {
  final storage = FlutterSecureStorage();

  final accessToken = await storage.read(key: StringConst.accessTokenKey);
  final refreshToken = await storage.read(key: StringConst.refreshTokenKey);
  final userDataJson = await storage.read(key: StringConst.userDataKey);

  ref.read(selelctedCityProvider.notifier).state =
      await storage.read(key: StringConst.selectedCityKey) ?? 'Islamabad';

  if (accessToken != null &&
      accessToken.isNotEmpty &&
      refreshToken != null &&
      refreshToken.isNotEmpty &&
      userDataJson != null) {
    try {
      final userData = jsonDecode(userDataJson);
      return UserSession(
        isLoggedIn: true,
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: UserModel.fromJson(userData),
      );
    } catch (e) {
      await ref.read(authControllerProvider).logout();
      return UserSession.loggedOut();
    }
  } else {
    return UserSession.loggedOut();
  }
});

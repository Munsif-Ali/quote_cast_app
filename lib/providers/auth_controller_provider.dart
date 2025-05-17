import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/api_service.dart';

final authControllerProvider = Provider((ref) => AuthController(ref));

class AuthController {
  final Ref ref;

  AuthController(this.ref);

  Future<void> login(String email, String password) async {
    final api = ref.read(apiServiceProvider);
    log("Logging in with email: $email and password: $password");
    await api.login(email, password);
  }

  Future<void> register(String username, String email, String password) async {
    final api = ref.read(apiServiceProvider);
    await api.register(username, email, password);
  }

  Future<void> logout() async {
    final api = ref.read(apiServiceProvider);
    await api.logout();
  }
}

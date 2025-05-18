import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:quote_cast_app/core/constants/app_routes.dart';
import 'package:quote_cast_app/core/extensions/context_extension.dart';
import 'package:quote_cast_app/core/extensions/string_extension.dart';
import 'package:quote_cast_app/core/styles/app_colors.dart';
import 'package:quote_cast_app/data/models/api_exception.dart';
import 'package:quote_cast_app/providers/auth_controller_provider.dart';

import '../providers/user_session_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome Back',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Login',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.isEmail) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: passwordVisible
                          ? const Icon(Icons.visibility, key: ValueKey(1))
                          : const Icon(Icons.visibility_off, key: ValueKey(2)),
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !passwordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child:
                    FilledButton(onPressed: login, child: const Text('Login')),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Sign Up',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.navigateAndReplace(AppRoutes.register);
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      log("Loging in");
      try {
        FocusManager.instance.primaryFocus?.unfocus();
        final email = _emailController.text;
        final password = _passwordController.text;
        context.loaderOverlay.show();

        await ref.read(authControllerProvider).login(email, password);

        if (!mounted) return;
        context.loaderOverlay.hide();

        context.showSnackBar('Login successful');
        ref.invalidate(userSessionProvider);
        context.navigateAndRemoveUntil(AppRoutes.home);
      } on ApiException catch (e) {
        context.loaderOverlay.hide();
        context.showSnackBar(
          'Login failed: ${e.message}',
          isError: true,
        );
      } catch (e, st) {
        log('Error: $e', stackTrace: st);
        context.loaderOverlay.hide();
        context.showSnackBar('Login failed: $e', isError: true);
      } finally {
        context.loaderOverlay.hide();
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

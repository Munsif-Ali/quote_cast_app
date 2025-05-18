import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:quote_cast_app/core/constants/app_routes.dart';
import 'package:quote_cast_app/core/extensions/context_extension.dart';

import '../../providers/auth_controller_provider.dart';
import '../../providers/user_session_provider.dart';

import 'package:shimmer/shimmer.dart';

class HomeDrawer extends ConsumerWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(context, ref) {
    final userSessionAsync = ref.watch(userSessionProvider);
    return Drawer(
      child: userSessionAsync.when(
        data: (userSession) {
          final user = userSession.user;
          return Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text("${user?.username}"),
                accountEmail: Text("${user?.email}"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    userSession.user?.username.substring(0, 1) ?? 'G',
                    style: const TextStyle(fontSize: 40.0, color: Colors.black),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  try {
                    context.loaderOverlay.show();

                    await ref.read(authControllerProvider).logout();

                    if (!context.mounted) return;
                    context.loaderOverlay.hide();

                    context.showSnackBar('Logged out successfully');

                    ref.invalidate(userSessionProvider);

                    context.navigateAndRemoveUntil(AppRoutes.login);
                  } catch (e) {
                    context.loaderOverlay.hide();

                    context.showSnackBar(
                      'Error logging out: $e',
                      isError: true,
                    );
                  }
                },
              ),
            ],
          );
        },
        error: (error, st) {
          return Center(child: Text('Error: $error'));
        },
        loading: () => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: const ListTile(
            leading: CircleAvatar(),
            title: Text('Loading...'),
          ),
        ),
      ),
    );
  }
}

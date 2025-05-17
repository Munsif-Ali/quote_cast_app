import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_cast_app/data/models/user_model.dart';
import 'package:quote_cast_app/screens/home/user_table_shimmer.dart';

import '../../data/services/api_service.dart';

class AllUsersTable extends ConsumerWidget {
  const AllUsersTable({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final allUsersAsyncValue = ref.watch(allUsersProvider);
    return allUsersAsyncValue.when(
      data: (users) {
        if (users.isEmpty) {
          return const Center(child: Text('No users found.'));
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Username')),
              DataColumn(label: Text('Email')),
            ],
            rows: users.map((user) {
              return DataRow(cells: [
                DataCell(Text(user.id)),
                DataCell(Text(user.username)),
                DataCell(Text(user.email)),
              ]);
            }).toList(),
          ),
        );
      },
      loading: () => UserTableShimmer(),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

final allUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  final users = await apiService.getAllUsers();
  return users;
});

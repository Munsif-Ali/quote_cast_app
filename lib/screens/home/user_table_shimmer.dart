import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserTableShimmer extends StatelessWidget {
  const UserTableShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: SizedBox(width: 50)),
            DataColumn(label: SizedBox(width: 100)),
            DataColumn(label: SizedBox(width: 150)),
          ],
          rows: List.generate(
            3,
            (index) => DataRow(
              cells: const [
                DataCell(
                  SizedBox(
                    width: 50,
                    height: 16,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 100,
                    height: 16,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 150,
                    height: 16,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

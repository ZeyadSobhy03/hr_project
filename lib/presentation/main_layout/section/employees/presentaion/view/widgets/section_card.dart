import 'package:flutter/material.dart';

import '../../../../../../../core/resources/colors/color_manger.dart';


class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.title, required this.rows});


  final String title;
  final List<List<Widget>> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorManger.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorManger.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: ColorManger.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          for (final row in rows) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: row[0]),
                const SizedBox(width: 20),
                Expanded(child: row[1]),
              ],
            ),
            const SizedBox(height: 18),
          ],
        ],
      ),
    );
  }
}

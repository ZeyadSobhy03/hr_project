import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

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
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1) const SizedBox(height: 18),
          ],
        ],
      ),
    );
  }
}
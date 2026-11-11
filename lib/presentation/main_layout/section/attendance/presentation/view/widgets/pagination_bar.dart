import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/widgets/custom_button.dart';

class PaginationBar extends StatelessWidget {
  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  final int currentPage; // 1-based
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          text: '<',
          type: ButtonType.secondary,
          onPressed: currentPage > 1
              ? () => onPageChanged(currentPage - 1)
              : null,
        ),
        const SizedBox(width: 8),
        CustomButton(text: '$currentPage', onPressed: () {}),
        const SizedBox(width: 8),
        CustomButton(
          text: '>',
          type: ButtonType.secondary,
          onPressed: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
      ],
    );
  }
}
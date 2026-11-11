import 'package:flutter/material.dart';

import '../../../../../../../core/resources/widgets/custom_button.dart';

Widget retry(String message, void Function()? onPressed) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 48),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 16),
          CustomButton(text: 'إعادة المحاولة', onPressed: onPressed),
        ],
      ),
    ),
  );
}

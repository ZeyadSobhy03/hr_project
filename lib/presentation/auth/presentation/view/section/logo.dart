import 'package:flutter/material.dart';

import '../../../../../core/resources/colors/color_manger.dart';
import '../../../../../core/resources/style/style_manger.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorManger.white,
            border: Border.all(color: ColorManger.primaryLogo, width: 4),
          ),
          child: const Text(
            'P',
            style: TextStyle(
              color: ColorManger.primaryLogo,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Text('Pioneers Solutions', style: AppStyles.logo),
      ],
    );
  }
}

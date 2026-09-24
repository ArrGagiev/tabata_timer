import 'package:flutter/material.dart';

import 'app_number_field.dart';

class AppDurationFields extends StatelessWidget {
  const AppDurationFields({
    super.key,
    required this.minutesController,
    required this.secondsController,
  });

  final TextEditingController minutesController;
  final TextEditingController secondsController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppNumberField(
            controller: minutesController,
            label: 'Minutes',
            maxValue: 59,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppNumberField(
            controller: secondsController,
            label: 'Seconds',
            maxValue: 59,
          ),
        ),
      ],
    );
  }
}

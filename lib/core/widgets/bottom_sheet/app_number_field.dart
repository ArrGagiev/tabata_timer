import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppNumberField extends StatelessWidget {
  const AppNumberField({
    super.key,
    required this.controller,
    required this.label,
    this.maxValue,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String label;
  final int? maxValue;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: textInputAction,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        if (maxValue != null)
          LengthLimitingTextInputFormatter(maxValue.toString().length),
        if (maxValue != null) _MaxValueInputFormatter(maxValue!),
      ],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _MaxValueInputFormatter extends TextInputFormatter {
  _MaxValueInputFormatter(this.maxValue);

  final int maxValue;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final int? value = int.tryParse(newValue.text);

    if (value == null || value > maxValue) {
      return oldValue;
    }

    return newValue;
  }
}

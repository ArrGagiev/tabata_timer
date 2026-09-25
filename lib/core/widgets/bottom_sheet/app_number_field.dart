import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_typography.dart';

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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

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
      cursorColor: colorScheme.primary,
      style: context.typography.bodyRegular,
      decoration: InputDecoration(
        labelText: label,

        labelStyle: context.typography.bodyRegular.copyWith(
          color: colorScheme.onSurface.withAlpha(150),
        ),
        floatingLabelStyle: context.typography.bodyRegular.copyWith(
          color: colorScheme.primary,
        ),

        filled: true,
        fillColor: colorScheme.surface,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.onSurface.withAlpha(35),
            width: 1,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.onSurface.withAlpha(35),
            width: 1,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
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

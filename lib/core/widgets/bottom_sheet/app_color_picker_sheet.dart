import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'app_bottom_sheet.dart';

class AppColorPickerSheet extends StatefulWidget {
  const AppColorPickerSheet({super.key, required this.currentColor});

  final int currentColor;

  static Future<int?> show(BuildContext context, {required int currentColor}) {
    return AppBottomSheet.show<int>(
      context: context,
      title: 'Change color',
      builder: (_) => AppColorPickerSheet(currentColor: currentColor),
    );
  }

  @override
  State<AppColorPickerSheet> createState() => _AppColorPickerSheetState();
}

class _AppColorPickerSheetState extends State<AppColorPickerSheet> {
  late int _selectedColor;

  @override
  void initState() {
    super.initState();

    _selectedColor = widget.currentColor;
  }

  void _save() {
    Navigator.pop(context, _selectedColor);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: AppColors.blockAccentColors.map((color) {
            final int colorValue = color.toARGB32();
            final bool isSelected = colorValue == _selectedColor;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = colorValue;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: colorScheme.onSurface, width: 3)
                      : null,
                ),
                child: isSelected
                    ? Icon(Icons.check, color: colorScheme.onPrimary)
                    : null,
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 28),

        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}

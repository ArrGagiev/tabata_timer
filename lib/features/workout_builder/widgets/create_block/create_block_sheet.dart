import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/bottom_sheet/app_bottom_sheet.dart';
import '../../../../core/widgets/bottom_sheet/app_duration_fields.dart';
import '../../../../core/widgets/bottom_sheet/app_sheet_button.dart';
import '../../../../core/widgets/bottom_sheet/app_text_field.dart';
import '../../../../core/widgets/bottom_sheet/app_number_field.dart';
import '../../domain/models/workout_block.dart';

enum CreateBlockType { exercise, timer, rest }

class CreateBlockSheet extends StatefulWidget {
  const CreateBlockSheet({super.key, required this.blockType});

  final CreateBlockType blockType;

  static Future<WorkoutBlock?> show(
    BuildContext context,
    CreateBlockType blockType,
  ) {
    return AppBottomSheet.show<WorkoutBlock>(
      context: context,
      title: switch (blockType) {
        CreateBlockType.exercise => 'Add Exercise',
        CreateBlockType.timer => 'Add Timer',
        CreateBlockType.rest => 'Add Rest',
      },
      builder: (_) => CreateBlockSheet(blockType: blockType),
    );
  }

  @override
  State<CreateBlockSheet> createState() => _CreateBlockSheetState();
}

class _CreateBlockSheetState extends State<CreateBlockSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _repetitionsController;
  late final TextEditingController _minutesController;
  late final TextEditingController _secondsController;

  late int _selectedColor;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: switch (widget.blockType) {
        CreateBlockType.exercise => 'Exercise',
        CreateBlockType.timer => 'Timer',
        CreateBlockType.rest => 'Rest',
      },
    );

    _repetitionsController = TextEditingController(text: '10');

    _minutesController = TextEditingController(text: '0');

    _secondsController = TextEditingController(text: '30');

    _selectedColor = switch (widget.blockType) {
      CreateBlockType.exercise => 0xFFFF9800,
      CreateBlockType.timer => 0xFF2196F3,
      CreateBlockType.rest => 0xFF16831F,
    };
  }

  @override
  void dispose() {
    _nameController.dispose();
    _repetitionsController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _save() {
    final String title = _nameController.text.trim();

    if (title.isEmpty) {
      return;
    }

    final String id = DateTime.now().microsecondsSinceEpoch.toString();

    final int repetitions = int.tryParse(_repetitionsController.text) ?? 1;

    final int minutes = int.tryParse(_minutesController.text) ?? 0;

    final int seconds = int.tryParse(_secondsController.text) ?? 0;

    final WorkoutBlock block = switch (widget.blockType) {
      CreateBlockType.exercise => ExerciseBlock(
        id: id,
        title: title,
        repetitions: repetitions,
        accentColor: _selectedColor,
      ),

      CreateBlockType.timer => TimerBlock(
        id: id,
        title: title,
        duration: Duration(minutes: minutes, seconds: seconds),
        accentColor: _selectedColor,
      ),

      CreateBlockType.rest => RestBlock(
        id: id,
        title: title,
        duration: Duration(minutes: minutes, seconds: seconds),
        accentColor: _selectedColor,
      ),
    };

    Navigator.pop(context, block);
  }

  @override
  Widget build(BuildContext context) {
    final bool isExercise = widget.blockType == CreateBlockType.exercise;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _nameController,
          label: 'Name',
          textInputAction: isExercise
              ? TextInputAction.next
              : TextInputAction.done,
        ),

        const SizedBox(height: 16),

        if (isExercise)
          AppNumberField(
            controller: _repetitionsController,
            label: 'Repetitions',
            textInputAction: TextInputAction.done,
          )
        else
          AppDurationFields(
            minutesController: _minutesController,
            secondsController: _secondsController,
          ),

        const SizedBox(height: 24),

        Text('Color', style: Theme.of(context).textTheme.titleMedium),

        const SizedBox(height: 12),

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
                      ? Border.all(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 3,
                        )
                      : null,
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 28),

        AppSheetButton(label: 'Add', onPressed: _save),
      ],
    );
  }
}

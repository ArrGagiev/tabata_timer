import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/workout_block.dart';

enum CreateBlockType { exercise, timer, rest }

class CreateBlockSheet extends StatefulWidget {
  const CreateBlockSheet({super.key, required this.blockType});

  final CreateBlockType blockType;

  static Future<WorkoutBlock?> show(
    BuildContext context,
    CreateBlockType blockType,
  ) {
    return showModalBottomSheet<WorkoutBlock>(
      context: context,
      isScrollControlled: true,
      builder: (_) => CreateBlockSheet(blockType: blockType),
    );
  }

  @override
  State<CreateBlockSheet> createState() => _CreateBlockSheetState();
}

class _CreateBlockSheetState extends State<CreateBlockSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _repetitionsController;

  late int _selectedColor;

  int _minutes = 0;
  int _seconds = 30;

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
    super.dispose();
  }

  void _save() {
    final String title = _nameController.text.trim();

    if (title.isEmpty) {
      return;
    }

    final String id = DateTime.now().microsecondsSinceEpoch.toString();

    final WorkoutBlock block = switch (widget.blockType) {
      CreateBlockType.exercise => ExerciseBlock(
        id: id,
        title: title,
        repetitions: int.tryParse(_repetitionsController.text) ?? 1,
        accentColor: _selectedColor,
      ),
      CreateBlockType.timer => TimerBlock(
        id: id,
        title: title,
        duration: Duration(minutes: _minutes, seconds: _seconds),
        accentColor: _selectedColor,
      ),
      CreateBlockType.rest => RestBlock(
        id: id,
        title: title,
        duration: Duration(minutes: _minutes, seconds: _seconds),
        accentColor: _selectedColor,
      ),
    };

    Navigator.pop(context, block);
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    final String title = switch (widget.blockType) {
      CreateBlockType.exercise => 'Add Exercise',
      CreateBlockType.timer => 'Add Timer',
      CreateBlockType.rest => 'Add Rest',
    };

    final bool isExercise = widget.blockType == CreateBlockType.exercise;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),

            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            if (isExercise)
              TextField(
                controller: _repetitionsController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Repetitions',
                  border: OutlineInputBorder(),
                ),
              )
            else
              _DurationFields(
                minutes: _minutes,
                seconds: _seconds,
                onMinutesChanged: (value) {
                  setState(() {
                    _minutes = value;
                  });
                },
                onSecondsChanged: (value) {
                  setState(() {
                    _seconds = value;
                  });
                },
              ),

            const SizedBox(height: 24),

            Text('Color', style: Theme.of(context).textTheme.titleMedium),

            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: AppColors.blockAccentColors.map((color) {
                final int colorValue = color.value;
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

            FilledButton(onPressed: _save, child: const Text('Add')),
          ],
        ),
      ),
    );
  }
}

class _DurationFields extends StatelessWidget {
  const _DurationFields({
    required this.minutes,
    required this.seconds,
    required this.onMinutesChanged,
    required this.onSecondsChanged,
  });

  final int minutes;
  final int seconds;

  final ValueChanged<int> onMinutesChanged;
  final ValueChanged<int> onSecondsChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _NumberField(
            label: 'Minutes',
            value: minutes,
            onChanged: onMinutesChanged,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _NumberField(
            label: 'Seconds',
            value: seconds,
            onChanged: onSecondsChanged,
          ),
        ),
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;

  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value.toString(),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2),
        _MaxValueInputFormatter(59),
      ],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: (text) {
        final int? value = int.tryParse(text);

        if (value != null && value <= 59) {
          onChanged(value);
        }
      },
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

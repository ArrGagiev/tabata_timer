import 'package:flutter/material.dart';

import '../../../../core/widgets/bottom_sheet/app_bottom_sheet.dart';
import '../../../../core/widgets/bottom_sheet/app_duration_fields.dart';
import '../../../../core/widgets/bottom_sheet/app_number_field.dart';
import '../../../../core/widgets/bottom_sheet/app_sheet_button.dart';
import '../../../../core/widgets/bottom_sheet/app_text_field.dart';
import '../../domain/models/workout_block.dart';

class EditBlockSheet extends StatefulWidget {
  const EditBlockSheet({super.key, required this.block});

  final WorkoutBlock block;

  static Future<WorkoutBlock?> show(BuildContext context, WorkoutBlock block) {
    return AppBottomSheet.show<WorkoutBlock>(
      context: context,
      title: 'Edit Block',
      builder: (_) => EditBlockSheet(block: block),
    );
  }

  @override
  State<EditBlockSheet> createState() => _EditBlockSheetState();
}

class _EditBlockSheetState extends State<EditBlockSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _repetitionsController;
  late final TextEditingController _minutesController;
  late final TextEditingController _secondsController;

  bool get _isExercise => widget.block is ExerciseBlock;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.block.title);

    _repetitionsController = TextEditingController(
      text: _repetitions.toString(),
    );

    final Duration duration = switch (widget.block) {
      TimerBlock timer => timer.duration,
      RestBlock rest => rest.duration,
      _ => Duration.zero,
    };

    _minutesController = TextEditingController(
      text: duration.inMinutes.toString(),
    );

    _secondsController = TextEditingController(
      text: (duration.inSeconds % 60).toString(),
    );
  }

  int get _repetitions {
    return switch (widget.block) {
      ExerciseBlock exercise => exercise.repetitions,
      _ => 10,
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

    final int repetitions = int.tryParse(_repetitionsController.text) ?? 1;

    final int minutes = int.tryParse(_minutesController.text) ?? 0;

    final int seconds = int.tryParse(_secondsController.text) ?? 0;

    final WorkoutBlock updatedBlock = switch (widget.block) {
      ExerciseBlock exercise => ExerciseBlock(
        id: exercise.id,
        title: title,
        note: exercise.note,
        accentColor: exercise.accentColor,
        repetitions: repetitions,
        isCompleted: exercise.isCompleted,
      ),

      TimerBlock timer => TimerBlock(
        id: timer.id,
        title: title,
        note: timer.note,
        accentColor: timer.accentColor,
        duration: Duration(minutes: minutes, seconds: seconds),
      ),

      RestBlock rest => RestBlock(
        id: rest.id,
        title: title,
        note: rest.note,
        accentColor: rest.accentColor,
        duration: Duration(minutes: minutes, seconds: seconds),
      ),

      _ => widget.block,
    };

    Navigator.pop(context, updatedBlock);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _nameController,
          label: 'Name',
          textInputAction: _isExercise
              ? TextInputAction.next
              : TextInputAction.done,
        ),

        const SizedBox(height: 16),

        if (_isExercise)
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

        AppSheetButton(label: 'Save', onPressed: _save),
      ],
    );
  }
}

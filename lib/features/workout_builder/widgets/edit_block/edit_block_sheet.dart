import 'package:flutter/material.dart';

import '../../domain/models/workout_block.dart';

class EditBlockSheet extends StatefulWidget {
  const EditBlockSheet({super.key, required this.block});

  final WorkoutBlock block;

  static Future<WorkoutBlock?> show(BuildContext context, WorkoutBlock block) {
    return showModalBottomSheet<WorkoutBlock>(
      context: context,
      isScrollControlled: true,
      builder: (_) => EditBlockSheet(block: block),
    );
  }

  @override
  State<EditBlockSheet> createState() => _EditBlockSheetState();
}

class _EditBlockSheetState extends State<EditBlockSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _valueController;

  late int _minutes;
  late int _seconds;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.block.title);

    _valueController = TextEditingController(text: _repetitions.toString());

    final Duration duration = switch (widget.block) {
      TimerBlock timer => timer.duration,
      RestBlock rest => rest.duration,
      _ => Duration.zero,
    };

    _minutes = duration.inMinutes;
    _seconds = duration.inSeconds % 60;
  }

  int get _repetitions {
    return switch (widget.block) {
      ExerciseBlock exercise => exercise.repetitions,
      _ => 10,
    };
  }

  bool get _isExercise => widget.block is ExerciseBlock;

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _save() {
    final String title = _nameController.text.trim();

    if (title.isEmpty) {
      return;
    }

    final WorkoutBlock updatedBlock = switch (widget.block) {
      ExerciseBlock exercise => ExerciseBlock(
        id: exercise.id,
        title: title,
        note: exercise.note,
        accentColor: exercise.accentColor,
        repetitions: int.tryParse(_valueController.text) ?? 1,
        isCompleted: exercise.isCompleted,
      ),
      TimerBlock timer => TimerBlock(
        id: timer.id,
        title: title,
        note: timer.note,
        accentColor: timer.accentColor,
        duration: Duration(minutes: _minutes, seconds: _seconds),
      ),
      RestBlock rest => RestBlock(
        id: rest.id,
        title: title,
        note: rest.note,
        accentColor: rest.accentColor,
        duration: Duration(minutes: _minutes, seconds: _seconds),
      ),
      _ => widget.block,
    };

    Navigator.pop(context, updatedBlock);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Edit Block', style: Theme.of(context).textTheme.titleLarge),
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
            if (_isExercise)
              TextField(
                controller: _valueController,
                keyboardType: TextInputType.number,
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
            FilledButton(onPressed: _save, child: const Text('Save')),
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
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: (text) {
        final int? value = int.tryParse(text);

        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}

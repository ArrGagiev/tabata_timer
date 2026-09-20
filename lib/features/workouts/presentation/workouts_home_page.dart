import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tabata_timer/core/theme/app_colors.dart';

import '../../../core/theme/app_typography.dart';
import '../../workout_builder/domain/models/workout_block.dart';
import '../../workout_builder/presentation/workout_builder_page.dart';
import '../domain/models/workout.dart';
import '../widgets/create_workout_sheet.dart';
import '../widgets/workout_card.dart';

class WorkoutsHomePage extends StatefulWidget {
  const WorkoutsHomePage({super.key});

  @override
  State<WorkoutsHomePage> createState() => _WorkoutsHomePageState();
}

class _WorkoutsHomePageState extends State<WorkoutsHomePage> {
  final List<Workout> _workouts = [
    Workout(
      id: 'workout_1',
      title: 'Chest Day',
      blocks: const [
        ExerciseBlock(
          id: 'exercise_1',
          title: 'Push Ups',
          repetitions: 10,
          accentColor: 0xFF16831F,
        ),
      ],
    ),
    Workout(
      id: 'workout_2',
      title: 'Leg Day',
      blocks: const [
        ExerciseBlock(
          id: 'exercise_2',
          title: 'Squats',
          repetitions: 15,
          accentColor: 0xFFFF9800,
        ),
      ],
    ),
  ];

  Future<void> _createWorkout() async {
    final String? title = await CreateWorkoutSheet.show(context);

    if (title == null) {
      return;
    }

    final Color randomColor =
        AppColors.blockAccentColors[Random().nextInt(
          AppColors.blockAccentColors.length,
        )];

    final Workout workout = Workout(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      blocks: const [],
      accentColor: randomColor.toARGB32(),
    );

    await _openWorkout(workout, initiallyEditing: true);
  }

  Future<void> _openWorkout(
    Workout workout, {
    bool initiallyEditing = false,
  }) async {
    final Workout? updatedWorkout = await Navigator.push<Workout>(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutBuilderPage(
          workout: workout,
          initiallyEditing: initiallyEditing,
        ),
      ),
    );

    if (updatedWorkout == null) {
      return;
    }

    setState(() {
      final int index = _workouts.indexWhere(
        (item) => item.id == updatedWorkout.id,
      );

      if (index == -1) {
        _workouts.add(updatedWorkout);
      } else {
        _workouts[index] = updatedWorkout;
      }
    });
  }

  void _duplicateWorkout(Workout workout) {
    final String workoutId = DateTime.now().microsecondsSinceEpoch.toString();

    final Workout duplicate = Workout(
      id: workoutId,
      title: '${workout.title} Copy',
      accentColor: workout.accentColor,
      blocks: workout.blocks.map((block) {
        final String blockId =
            '${DateTime.now().microsecondsSinceEpoch}_${block.id}';

        return switch (block) {
          ExerciseBlock exercise => ExerciseBlock(
            id: blockId,
            title: exercise.title,
            note: exercise.note,
            accentColor: exercise.accentColor,
            repetitions: exercise.repetitions,
          ),
          TimerBlock timer => TimerBlock(
            id: blockId,
            title: timer.title,
            note: timer.note,
            accentColor: timer.accentColor,
            duration: timer.duration,
          ),
          RestBlock rest => RestBlock(
            id: blockId,
            title: rest.title,
            note: rest.note,
            accentColor: rest.accentColor,
            duration: rest.duration,
          ),
          _ => throw UnsupportedError('Unsupported workout block type'),
        };
      }).toList(),
    );

    setState(() {
      _workouts.add(duplicate);
    });
  }

  Future<void> _deleteWorkout(Workout workout) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete workout?'),
          content: Text('Are you sure you want to delete "${workout.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    final int index = _workouts.indexWhere((item) => item.id == workout.id);

    if (index == -1) {
      return;
    }

    setState(() {
      _workouts.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${workout.title}" deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _workouts.insert(index.clamp(0, _workouts.length), workout);
            });
          },
        ),
      ),
    );
  }

  void _changeWorkoutColor(Workout workout, int color) {
    setState(() {
      final int index = _workouts.indexWhere((item) => item.id == workout.id);

      if (index == -1) {
        return;
      }

      _workouts[index] = workout.copyWith(accentColor: color);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 24, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your workouts'.toUpperCase(),
                    style: context.typography.smallSemiBold.copyWith(
                      letterSpacing: 2.5,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha(120),
                    ),
                  ),
                  Text(
                    'Workouts'.toUpperCase(),
                    style: context.typography.headingLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _workouts.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final Workout workout = _workouts[index];

          return WorkoutCard(
            workout: workout,
            onTap: () => _openWorkout(workout),
            onDuplicate: () => _duplicateWorkout(workout),
            onDelete: () => _deleteWorkout(workout),
            onChangeColor: (color) {
              _changeWorkoutColor(workout, color);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createWorkout,
        child: const Icon(Icons.add),
      ),
    );
  }
}

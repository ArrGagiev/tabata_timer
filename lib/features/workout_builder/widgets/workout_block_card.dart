import 'package:flutter/material.dart';
import 'package:tabata_timer/features/workout_builder/domain/models/workout_block.dart';

class WorkoutBlockCard extends StatelessWidget {
  const WorkoutBlockCard({super.key, required this.block});

  final WorkoutBlock block;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: SizedBox(
        height: 88,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return switch (block) {
      ExerciseBlock exercise => Text(
        '${exercise.title}\n${exercise.repetitions} reps',
      ),
      TimerBlock timer => Text(
        '${timer.title}\n${timer.duration.inSeconds} sec',
      ),
      RestBlock rest => Text('${rest.title}\n${rest.duration.inSeconds} sec'),
      _ => const SizedBox.shrink(),
    };
  }
}

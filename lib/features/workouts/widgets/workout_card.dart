import 'package:flutter/material.dart';

import '../../../core/theme/app_typography.dart';
import '../../workout_builder/domain/models/workout_block.dart';
import '../domain/models/workout.dart';

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({super.key, required this.workout, required this.onTap});

  final Workout workout;
  final VoidCallback onTap;

  String _formatWorkoutDuration() {
    int totalSeconds = 0;

    for (final block in workout.blocks) {
      switch (block) {
        case ExerciseBlock exercise:
          totalSeconds += exercise.repetitions;

        case TimerBlock timer:
          totalSeconds += timer.duration.inSeconds;

        case RestBlock rest:
          totalSeconds += rest.duration.inSeconds;

        default:
          break;
      }
    }

    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;

    if (minutes == 0) {
      return '${seconds}s';
    }

    return '${minutes}m ${seconds.toString().padLeft(2, '0')}s';
  }

  String _getBlockTypeName(WorkoutBlock block) {
    return switch (block) {
      ExerciseBlock() => '● REPS',
      TimerBlock() => '● TIMER',
      RestBlock() => '● REST',
      _ => '',
    };
  }

  Widget _buildBlockChip(BuildContext context, WorkoutBlock block) {
    final Color blockColor = Color(block.accentColor);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: blockColor.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: blockColor.withAlpha(100)),
      ),
      child: Text(
        _getBlockTypeName(block),
        style: context.typography.smallBold.copyWith(color: blockColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(workout.title, style: context.typography.headingSmall),
                    const SizedBox(height: 8),

                    Text(
                      '${workout.blocks.length} blocks    ·    ~${_formatWorkoutDuration()}',
                      style: context.typography.bodyRegular.copyWith(
                        color: colorScheme.onSurface.withAlpha(90),
                      ),
                    ),
                    if (workout.blocks.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: workout.blocks
                            .map((block) => _buildBlockChip(context, block))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 54,
                height: 96,

                child: Center(
                  child: Text(
                    '${workout.blocks.length}',
                    style: context.typography.headingLarge.copyWith(
                      fontSize: 88,
                      color: colorScheme.onSurface.withAlpha(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tabata_timer/core/theme/app_typography.dart';
import 'package:tabata_timer/features/workout_builder/widgets/painters/dashed_border_painter.dart';

class WorkoutActionButton extends StatelessWidget {
  const WorkoutActionButton({
    super.key,
    required this.isEditing,
    required this.onPressed,
  });

  final bool isEditing;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return isEditing
        ? _AddBlockButton(onPressed: onPressed)
        : _StartWorkoutButton(onPressed: onPressed);
  }
}

class _AddBlockButton extends StatelessWidget {
  const _AddBlockButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomPaint(
      painter: DashedBorderPainter(color: colorScheme.primary, radius: 16),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(72),
          // padding: const EdgeInsets.symmetric(horizontal: 16),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          foregroundColor: colorScheme.brightness == Brightness.dark
              ? colorScheme.onSurface
              : colorScheme.primary,
          textStyle: context.typography.mediumBold,
          backgroundColor: colorScheme.primary.withAlpha(60),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.add), SizedBox(width: 8), Text('Add Block')],
        ),
      ),
    );
  }
}

class _StartWorkoutButton extends StatelessWidget {
  const _StartWorkoutButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(72),
        // padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        textStyle: context.typography.mediumBold,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.play_arrow),
          SizedBox(width: 8),
          Text('Start Workout'),
        ],
      ),
    );
  }
}

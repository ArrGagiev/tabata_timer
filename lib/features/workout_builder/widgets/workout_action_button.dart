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
    final colorScheme = Theme.of(context).colorScheme;

    final button = OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 24),
        minimumSize: Size.zero,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: isEditing ? Colors.transparent : colorScheme.primary,
        foregroundColor: isEditing
            ? colorScheme.onSurface
            : colorScheme.onPrimary,
        textStyle: context.typography.mediumBold,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isEditing) ...[
            const Icon(Icons.play_arrow),
            const SizedBox(width: 8),
          ],
          Text(isEditing ? '+ Add Block' : 'Start Workout'),
        ],
      ),
    );

    if (!isEditing) {
      return button;
    }

    return CustomPaint(
      painter: DashedBorderPainter(color: colorScheme.primary, radius: 12),
      child: button,
    );
  }
}

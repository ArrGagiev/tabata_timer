import 'package:flutter/material.dart';

import '../../../core/theme/app_typography.dart';
import '../../workout_builder/domain/models/workout_block.dart';
import '../domain/models/workout.dart';

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({
    super.key,
    required this.workout,
    required this.onTap,
    required this.onDuplicate,
    required this.onDelete,
    required this.onChangeColor,
  });

  final Workout workout;
  final VoidCallback onTap;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final ValueChanged<int> onChangeColor;

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
      ExerciseBlock() => '• REPS',
      TimerBlock() => '• TIMER',
      RestBlock() => '• REST',
      _ => '',
    };
  }

  Widget _buildBlockChip(BuildContext context, WorkoutBlock block) {
    final Color blockColor = Color(block.accentColor);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: blockColor.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: blockColor.withAlpha(100)),
      ),
      child: Text(
        _getBlockTypeName(block),
        style: context.typography.smallBold.copyWith(
          color: blockColor,
          letterSpacing: 0.9,
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    const List<int> colors = [
      0xFF6C63FF,
      0xFF16831F,
      0xFFFF9800,
      0xFFE53935,
      0xFF00A6A6,
      0xFF9C27B0,
      0xFF2196F3,
    ];

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final Color surfaceColor = Theme.of(context).colorScheme.surface;

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: colors.map((value) {
              final Color color = Color(value);

              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onChangeColor(value);
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: surfaceColor, width: 2),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color accentColor = Color(workout.accentColor);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.centerLeft, // Начало градиента слева
          end: Alignment.centerRight, // Конец градиента справа
          colors: [
            accentColor.withAlpha(100), // Исходный цвет слева
            accentColor.withAlpha(30), // Полностью прозрачный цвет справа
          ],
        ),
      ),

      padding: const EdgeInsets.all(2.5),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [accentColor.withAlpha(10), Colors.transparent],
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout.title,
                          style: context.typography.headingSmall,
                        ),
                        Text(
                          '${workout.blocks.length} blocks · '
                          '~${_formatWorkoutDuration()}',
                          style: context.typography.bodyRegular.copyWith(
                            color: colorScheme.onSurface.withAlpha(90),
                          ),
                        ),
                        if (workout.blocks.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 4,
                            runSpacing: 6,
                            children: workout.blocks
                                // Берет только первые N элементов
                                // (или меньше, если их всего < N)
                                .take(5)
                                .map((block) => _buildBlockChip(context, block))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      // Количество блоков
                      Padding(
                        padding: const EdgeInsets.only(right: 16, left: 12),
                        child: ShaderMask(
                          // Указывает, что градиент должен красить только сам текст
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.centerRight,
                            colors: [
                              // Исходный цвет слева
                              colorScheme.onSurface.withAlpha(20),
                              // Уходит в прозрачный справа
                              colorScheme.onSurface.withAlpha(5),
                            ],
                          ).createShader(bounds),
                          child: Text(
                            '${workout.blocks.length}',
                            style: context.typography.headingLarge.copyWith(
                              fontSize: 80,
                              height: 1.1,
                              // ОБЯЗАТЕЛЬНО белый, чтобы градиент лег корректно
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // Меню поверх, в правом верхнем углу
                      Positioned(
                        top: -12,
                        right: -16,
                        child: PopupMenuButton<String>(
                          style: ButtonStyle(
                            overlayColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),
                          ),
                          icon: const Icon(Icons.more_vert),
                          tooltip: 'Workout options',
                          padding: EdgeInsets.zero,
                          onSelected: (value) {
                            switch (value) {
                              case 'duplicate':
                                onDuplicate();

                              case 'color':
                                _showColorPicker(context);

                              case 'delete':
                                onDelete();
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'duplicate',
                              child: Text('Duplicate'),
                            ),
                            PopupMenuItem(
                              value: 'color',
                              child: Text('Change color'),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tabata_timer/features/workout_builder/domain/models/workout_block.dart';

class WorkoutBlockCard extends StatelessWidget {
  const WorkoutBlockCard({
    super.key,
    required this.block,
    required this.isEditing,
    required this.onEdit,
    required this.onDuplicate,
    required this.onChangeColor,
    required this.onDelete,
  });

  final WorkoutBlock block;
  final bool isEditing;

  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onChangeColor;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: SizedBox(
        height: 88,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          child: Row(
            children: [
              _buildAccentIndicator(),
              const SizedBox(width: 12),
              Expanded(child: _buildContent()),
              if (isEditing)
                PopupMenuButton<_BlockMenuAction>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (action) {
                    switch (action) {
                      case _BlockMenuAction.edit:
                        onEdit();

                      case _BlockMenuAction.duplicate:
                        onDuplicate();

                      case _BlockMenuAction.changeColor:
                        onChangeColor();

                      case _BlockMenuAction.delete:
                        onDelete();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: _BlockMenuAction.edit,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.edit_outlined),
                        title: Text('Edit'),
                      ),
                    ),
                    PopupMenuItem(
                      value: _BlockMenuAction.duplicate,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.copy_outlined),
                        title: Text('Duplicate'),
                      ),
                    ),
                    PopupMenuItem(
                      value: _BlockMenuAction.changeColor,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.palette_outlined),
                        title: Text('Change color'),
                      ),
                    ),
                    PopupMenuItem(
                      value: _BlockMenuAction.delete,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.delete_outline),
                        title: Text('Delete'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccentIndicator() {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: Color(block.accentColor),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildContent() {
    return switch (block) {
      ExerciseBlock exercise => Text(
        '${exercise.title}\n${exercise.repetitions} reps',
      ),
      TimerBlock timer => Text(
        '${timer.title}\n${_formatDuration(timer.duration)}',
      ),
      RestBlock rest => Text(
        '${rest.title}\n${_formatDuration(rest.duration)}',
      ),
      _ => const SizedBox.shrink(),
    };
  }

  String _formatDuration(Duration duration) {
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}

enum _BlockMenuAction { edit, duplicate, changeColor, delete }

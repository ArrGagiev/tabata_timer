import 'package:flutter/material.dart';
import 'package:tabata_timer/core/theme/app_typography.dart';
import 'package:tabata_timer/core/theme/app_colors.dart';

import '../../workouts/domain/models/workout.dart';
import '../domain/models/workout_block.dart';
import '../widgets/add_block/add_block_sheet.dart';
import '../widgets/create_block/create_block_sheet.dart';
import '../widgets/workout_action_button.dart';
import '../widgets/workout_blocks_list.dart';
import '../widgets/edit_block/edit_block_sheet.dart';

class WorkoutBuilderPage extends StatefulWidget {
  const WorkoutBuilderPage({
    super.key,
    required this.workout,
    this.initiallyEditing = false,
  });

  final Workout workout;
  final bool initiallyEditing;

  @override
  State<WorkoutBuilderPage> createState() => _WorkoutBuilderPageState();
}

class _WorkoutBuilderPageState extends State<WorkoutBuilderPage> {
  bool _isEditing = false;

  late final TextEditingController _workoutTitleController;

  late List<WorkoutBlock> _blocks;

  String _workoutTitle = '';

  @override
  void initState() {
    super.initState();

    _workoutTitle = widget.workout.title;
    _blocks = List.of(widget.workout.blocks);

    _workoutTitleController = TextEditingController(text: _workoutTitle);

    _isEditing = widget.initiallyEditing;
  }

  @override
  void dispose() {
    _workoutTitleController.dispose();
    super.dispose();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final WorkoutBlock block = _blocks.removeAt(oldIndex);

      _blocks.insert(newIndex, block);
    });
  }

  void _saveWorkout() {
    final String title = _workoutTitleController.text.trim();

    if (title.isEmpty) {
      return;
    }

    final Workout workout = Workout(
      id: widget.workout.id,
      title: title,
      blocks: List.unmodifiable(_blocks),
    );

    Navigator.pop(context, workout);
  }

  void _toggleEditing() {
    if (_isEditing) {
      _saveWorkout();
      return;
    }

    _workoutTitleController.text = _workoutTitle;

    setState(() {
      _isEditing = true;
    });
  }

  Future<void> _onAddBlock() async {
    final AddBlockType? blockType = await AddBlockSheet.show(context);

    if (blockType == null) {
      return;
    }

    final CreateBlockType createBlockType = switch (blockType) {
      AddBlockType.exercise => CreateBlockType.exercise,
      AddBlockType.timer => CreateBlockType.timer,
      AddBlockType.rest => CreateBlockType.rest,
    };

    final WorkoutBlock? newBlock = await CreateBlockSheet.show(
      context,
      createBlockType,
    );

    if (newBlock == null) {
      return;
    }

    setState(() {
      _blocks.add(newBlock);
    });
  }

  // Отвечает за редактирование блока
  Future<void> _onEditBlock(WorkoutBlock block) async {
    final WorkoutBlock? updatedBlock = await EditBlockSheet.show(
      context,
      block,
    );

    if (updatedBlock == null) {
      return;
    }

    setState(() {
      final int index = _blocks.indexWhere((item) => item.id == block.id);

      if (index != -1) {
        _blocks[index] = updatedBlock;
      }
    });
  }

  Future<void> _onDuplicateBlock(WorkoutBlock block) async {
    final bool? shouldDuplicate = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Duplicate block?'),
          content: Text('Do you want to duplicate "${block.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('No'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldDuplicate != true) {
      return;
    }

    final WorkoutBlock duplicatedBlock = _duplicateBlock(block);

    setState(() {
      final int index = _blocks.indexWhere((item) => item.id == block.id);

      if (index != -1) {
        _blocks.insert(index + 1, duplicatedBlock);
      }
    });
  }

  WorkoutBlock _duplicateBlock(WorkoutBlock block) {
    final String newId = DateTime.now().microsecondsSinceEpoch.toString();

    return switch (block) {
      ExerciseBlock exercise => ExerciseBlock(
        id: newId,
        title: exercise.title,
        note: exercise.note,
        accentColor: exercise.accentColor,
        repetitions: exercise.repetitions,
        isCompleted: exercise.isCompleted,
      ),
      TimerBlock timer => TimerBlock(
        id: newId,
        title: timer.title,
        note: timer.note,
        accentColor: timer.accentColor,
        duration: timer.duration,
      ),
      RestBlock rest => RestBlock(
        id: newId,
        title: rest.title,
        note: rest.note,
        accentColor: rest.accentColor,
        duration: rest.duration,
      ),
      _ => block,
    };
  }

  Future<void> _onDeleteBlock(WorkoutBlock block) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete block?'),
          content: Text('Do you want to delete "${block.title}"?'),
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

    if (shouldDelete != true) {
      return;
    }

    setState(() {
      _blocks.removeWhere((item) => item.id == block.id);
    });
  }

  Future<void> _onChangeBlockColor(WorkoutBlock block) async {
    final int? selectedColor = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return _BlockColorSheet(currentColor: block.accentColor);
      },
    );

    if (selectedColor == null) {
      return;
    }

    setState(() {
      final int index = _blocks.indexWhere((item) => item.id == block.id);

      if (index == -1) {
        return;
      }

      final WorkoutBlock updatedBlock = switch (block) {
        ExerciseBlock exercise => ExerciseBlock(
          id: exercise.id,
          title: exercise.title,
          note: exercise.note,
          accentColor: selectedColor,
          repetitions: exercise.repetitions,
          isCompleted: exercise.isCompleted,
        ),
        TimerBlock timer => TimerBlock(
          id: timer.id,
          title: timer.title,
          note: timer.note,
          accentColor: selectedColor,
          duration: timer.duration,
        ),
        RestBlock rest => RestBlock(
          id: rest.id,
          title: rest.title,
          note: rest.note,
          accentColor: selectedColor,
          duration: rest.duration,
        ),
        _ => block,
      };

      _blocks[index] = updatedBlock;
    });
  }

  void _onStartWorkout() {
    // TODO: Запуск тренировки
  }

  String _formatWorkoutDuration() {
    int totalSeconds = 0;

    for (final block in _blocks) {
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

  Widget _buildWorkoutTitle(BuildContext context) {
    if (_isEditing) {
      return SizedBox(
        height: 40,
        child: TextField(
          controller: _workoutTitleController,
          textInputAction: TextInputAction.done,
          textAlignVertical: TextAlignVertical.center,
          style: context.typography.headingMedium,
          decoration: const InputDecoration(
            hintText: 'Workout name',
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      );
    }

    return SizedBox(
      height: 40,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(_workoutTitle, style: context.typography.headingMedium),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                textStyle: context.typography.bodySemiBold,
              ),
              onPressed: _toggleEditing,
              child: Text(_isEditing ? 'Save' : 'Edit'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWorkoutTitle(context),
                const SizedBox(height: 4),
                Text(
                  '${_blocks.length} blocks · ~${_formatWorkoutDuration()}',
                  style: context.typography.bodySmall.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(130),
                  ),
                ),
                const SizedBox(height: 12),
                Divider(
                  height: 1,
                  color: Theme.of(context).dividerColor.withAlpha(50),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: _blocks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.fitness_center_outlined,
                                size: 48,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withAlpha(100),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No blocks yet',
                                style: context.typography.mediumBold,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Tap Edit to add blocks',
                                style: context.typography.bodyRegular.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withAlpha(130),
                                ),
                              ),
                            ],
                          ),
                        )
                      : CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              sliver: WorkoutBlocksList(
                                blocks: _blocks,
                                isEditing: _isEditing,
                                onReorder: _onReorder,
                                onEdit: _onEditBlock,
                                onDuplicate: _onDuplicateBlock,
                                onChangeColor: _onChangeBlockColor,
                                onDelete: _onDeleteBlock,
                              ),
                            ),
                          ],
                        ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 16, 10, 24),
                  child: WorkoutActionButton(
                    isEditing: _isEditing,
                    onPressed: _isEditing ? _onAddBlock : _onStartWorkout,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockColorSheet extends StatefulWidget {
  const _BlockColorSheet({required this.currentColor});

  final int currentColor;

  @override
  State<_BlockColorSheet> createState() => _BlockColorSheetState();
}

class _BlockColorSheetState extends State<_BlockColorSheet> {
  late int _selectedColor;

  @override
  void initState() {
    super.initState();

    _selectedColor = widget.currentColor;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Change color', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
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
            FilledButton(
              onPressed: () {
                Navigator.pop(context, _selectedColor);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

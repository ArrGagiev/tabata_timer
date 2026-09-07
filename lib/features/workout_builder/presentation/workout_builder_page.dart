import 'package:flutter/material.dart';
import 'package:tabata_timer/core/theme/app_typography.dart';

import '../domain/models/workout_block.dart';
import '../widgets/add_block/add_block_sheet.dart';
import '../widgets/workout_action_button.dart';
import '../widgets/workout_blocks_list.dart';

class WorkoutBuilderPage extends StatefulWidget {
  const WorkoutBuilderPage({super.key});

  @override
  State<WorkoutBuilderPage> createState() => _WorkoutBuilderPageState();
}

class _WorkoutBuilderPageState extends State<WorkoutBuilderPage> {
  bool _isEditing = false;

  final List<WorkoutBlock> _blocks = [
    const ExerciseBlock(
      id: 'exercise_1',
      title: 'Push Ups',
      repetitions: 10,
      accentColor: 0xFF16831F,
    ),
    const RestBlock(
      id: 'rest_1',
      title: 'Rest',
      duration: Duration(seconds: 30),
      accentColor: 0xFF2196F3,
    ),
    const TimerBlock(
      id: 'timer_1',
      title: 'Plank',
      duration: Duration(seconds: 45),
      accentColor: 0xFFFF9800,
    ),
    const ExerciseBlock(
      id: 'exercise_2',
      title: 'Pull Ups',
      repetitions: 8,
      accentColor: 0xFF9C27B0,
    ),
    const RestBlock(
      id: 'rest_2',
      title: 'Long Rest',
      duration: Duration(seconds: 60),
      accentColor: 0xFF2196F3,
    ),
  ];

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final WorkoutBlock block = _blocks.removeAt(oldIndex);

      _blocks.insert(newIndex, block);
    });
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _onAddBlock() async {
    final AddBlockType? blockType = await AddBlockSheet.show(context);

    if (blockType == null) {
      return;
    }

    final WorkoutBlock newBlock = switch (blockType) {
      AddBlockType.exercise => ExerciseBlock(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: 'Exercise',
        repetitions: 10,
        accentColor: 0xFF16831F,
      ),
      AddBlockType.timer => TimerBlock(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: 'Timer',
        duration: const Duration(seconds: 30),
        accentColor: 0xFFFF9800,
      ),
      AddBlockType.rest => RestBlock(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: 'Rest',
        duration: const Duration(seconds: 30),
        accentColor: 0xFF2196F3,
      ),
    };

    setState(() {
      _blocks.add(newBlock);
    });
  }

  void _onStartWorkout() {
    // TODO: Запуск тренировки
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Builder'),
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
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: WorkoutBlocksList(blocks: _blocks, onReorder: _onReorder),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 16, 10, 24),
              child: WorkoutActionButton(
                isEditing: _isEditing,
                onPressed: _isEditing ? _onAddBlock : _onStartWorkout,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

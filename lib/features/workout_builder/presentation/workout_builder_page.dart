import 'package:flutter/material.dart';
import 'package:tabata_timer/features/workout_builder/domain/models/workout_block.dart';
import 'package:tabata_timer/features/workout_builder/widgets/workout_blocks_list.dart';

class WorkoutBuilderPage extends StatefulWidget {
  const WorkoutBuilderPage({super.key});

  @override
  State<WorkoutBuilderPage> createState() => _WorkoutBuilderPageState();
}

class _WorkoutBuilderPageState extends State<WorkoutBuilderPage> {
  final List<WorkoutBlock> _blocks = [
    const ExerciseBlock(
      id: 'exercise_1',
      title: 'Push Ups',
      repetitions: 10,
      accentColor: 0xFF4CAF50,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Builder')),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: WorkoutBlocksList(blocks: _blocks, onReorder: _onReorder),
          ),
        ],
      ),
    );
  }
}

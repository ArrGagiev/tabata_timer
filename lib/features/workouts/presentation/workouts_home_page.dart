import 'package:flutter/material.dart';

import '../domain/models/workout.dart';
import '../../workout_builder/domain/models/workout_block.dart';
import '../../workout_builder/presentation/workout_builder_page.dart';
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

    final Workout workout = Workout(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      blocks: const [],
    );

    await _openWorkout(workout);
  }

  Future<void> _openWorkout(Workout workout) async {
    final Workout? updatedWorkout = await Navigator.push<Workout>(
      context,
      MaterialPageRoute(builder: (_) => WorkoutBuilderPage(workout: workout)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workouts')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _workouts.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final Workout workout = _workouts[index];

          return WorkoutCard(
            workout: workout,
            onTap: () => _openWorkout(workout),
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

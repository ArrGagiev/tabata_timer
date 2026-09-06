import 'package:flutter/material.dart';
import 'package:tabata_timer/features/workout_builder/domain/models/workout_block.dart';

class ExerciseBlockCard extends StatelessWidget {
  const ExerciseBlockCard({super.key, required this.block});

  final ExerciseBlock block;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 100,
        child: Center(
          child: Text('${block.title} — ${block.repetitions} reps'),
        ),
      ),
    );
  }
}

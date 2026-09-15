import 'package:tabata_timer/features/workout_builder/domain/models/workout_block.dart';

class Workout {
  final String id;
  final String title;
  final List<WorkoutBlock> blocks;

  const Workout({required this.id, required this.title, required this.blocks});
}

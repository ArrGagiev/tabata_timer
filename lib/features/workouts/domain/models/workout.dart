import '../../../workout_builder/domain/models/workout_block.dart';

class Workout {
  final String id;
  final String title;
  final List<WorkoutBlock> blocks;
  final int accentColor;

  const Workout({
    required this.id,
    required this.title,
    required this.blocks,
    this.accentColor = 0xFF6C63FF,
  });

  Workout copyWith({
    String? id,
    String? title,
    List<WorkoutBlock>? blocks,
    int? accentColor,
  }) {
    return Workout(
      id: id ?? this.id,
      title: title ?? this.title,
      blocks: blocks ?? this.blocks,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}

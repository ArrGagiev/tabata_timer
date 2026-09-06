abstract class WorkoutBlock {
  final String id;
  final String title;
  final String? note;
  final int accentColor;

  const WorkoutBlock({
    required this.id,
    required this.title,
    this.note,
    required this.accentColor,
  });
}

/// Упражнение по количеству повторений.
class ExerciseBlock extends WorkoutBlock {
  final int repetitions;
  final bool isCompleted;

  const ExerciseBlock({
    required super.id,
    required super.title,
    super.note,
    required super.accentColor,
    required this.repetitions,
    this.isCompleted = false,
  });
}

/// Упражнение по времени.
class TimerBlock extends WorkoutBlock {
  final Duration duration;

  const TimerBlock({
    required super.id,
    required super.title,
    super.note,
    required super.accentColor,
    required this.duration,
  });
}

/// Отдых между упражнениями.
class RestBlock extends WorkoutBlock {
  final Duration duration;

  const RestBlock({
    required super.id,
    required super.title,
    super.note,
    required super.accentColor,
    required this.duration,
  });
}

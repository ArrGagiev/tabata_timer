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

/// Блок с упражнениями на количество повторений.
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

/// Блок с упражнениями на время.
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

/// Блок с отдыхом.
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

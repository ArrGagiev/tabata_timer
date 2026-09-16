import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tabata_timer/features/workout_builder/domain/models/workout_block.dart';
import 'package:tabata_timer/features/workouts/domain/models/workout.dart';

class WorkoutPlayerPage extends StatefulWidget {
  const WorkoutPlayerPage({super.key, required this.workout});

  final Workout workout;

  @override
  State<WorkoutPlayerPage> createState() => _WorkoutPlayerPageState();
}

class _WorkoutPlayerPageState extends State<WorkoutPlayerPage> {
  final ScrollController _scrollController = ScrollController();
  final Stopwatch _stopwatch = Stopwatch();

  late final List<GlobalKey> _blockKeys;

  Timer? _timer;

  int _currentBlockIndex = 0;

  Duration _remainingTime = Duration.zero;
  Duration _totalTime = Duration.zero;

  @override
  void initState() {
    super.initState();

    _blockKeys = List.generate(
      widget.workout.blocks.length,
      (_) => GlobalKey(),
    );

    _stopwatch.start();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCurrentBlock();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    _scrollController.dispose();

    super.dispose();
  }

  WorkoutBlock get _currentBlock => widget.workout.blocks[_currentBlockIndex];

  int get _completedCount => _currentBlockIndex;

  int get _remainingBlocks =>
      widget.workout.blocks.length - _completedCount - 1;

  double get _progress {
    if (widget.workout.blocks.isEmpty) {
      return 1;
    }

    return _completedCount / widget.workout.blocks.length;
  }

  void _startCurrentBlock() {
    _timer?.cancel();

    if (!mounted || widget.workout.blocks.isEmpty) {
      return;
    }

    final block = _currentBlock;

    if (block is TimerBlock) {
      _startTimer(block.duration);
    } else if (block is RestBlock) {
      _startTimer(block.duration);
    } else {
      setState(() {
        _remainingTime = Duration.zero;
        _totalTime = Duration.zero;
      });
    }

    _scrollToCurrentBlock();
  }

  void _startTimer(Duration duration) {
    _timer?.cancel();

    if (duration <= Duration.zero) {
      _completeCurrentBlock();
      return;
    }

    final startTime = DateTime.now();
    final endTime = startTime.add(duration);

    setState(() {
      _totalTime = duration;
      _remainingTime = duration;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted) {
        return;
      }

      final remaining = endTime.difference(DateTime.now());

      if (remaining <= Duration.zero) {
        _timer?.cancel();

        setState(() {
          _remainingTime = Duration.zero;
        });

        _completeCurrentBlock();
        return;
      }

      setState(() {
        _remainingTime = remaining;
      });
    });
  }

  void _completeCurrentBlock() {
    _timer?.cancel();

    if (!mounted) {
      return;
    }

    final isLastBlock = _currentBlockIndex == widget.workout.blocks.length - 1;

    if (isLastBlock) {
      _finishWorkout();
      return;
    }

    setState(() {
      _currentBlockIndex++;
      _remainingTime = Duration.zero;
      _totalTime = Duration.zero;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCurrentBlock();
    });
  }

  void _skipCurrentBlock() {
    _completeCurrentBlock();
  }

  void _finishWorkout() {
    _timer?.cancel();
    _stopwatch.stop();

    final elapsed = _stopwatch.elapsed;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          title: Column(
            children: [
              const Text('🏆', style: TextStyle(fontSize: 42)),
              const SizedBox(height: 12),
              Text(
                'Workout\nComplete!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'You crushed every block.\nGreat work.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Text(
                _formatElapsed(elapsed),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Done'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _scrollToCurrentBlock() {
    if (_currentBlockIndex == 0) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return;
    }

    final keyContext = _blockKeys[_currentBlockIndex].currentContext;

    if (keyContext == null) {
      return;
    }

    Scrollable.ensureVisible(
      keyContext,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      alignment: 0.45,
    );
  }

  String _formatElapsed(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    if (minutes == 0) {
      return '${seconds}s';
    }

    return '${minutes}m ${seconds.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Now playing', style: Theme.of(context).textTheme.labelMedium),
            Text(
              widget.workout.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Exit workout',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          _ProgressHeader(
            progress: _progress,
            completedCount: _completedCount,
            remainingCount: _remainingBlocks,
          ),
          Expanded(
            child: widget.workout.blocks.isEmpty
                ? const Center(child: Text('No blocks in this workout'))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                    itemCount: widget.workout.blocks.length,
                    itemBuilder: (context, index) {
                      final block = widget.workout.blocks[index];

                      final isActive = index == _currentBlockIndex;
                      final isCompleted = index < _currentBlockIndex;

                      return Padding(
                        key: _blockKeys[index],
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _PlayerBlockCard(
                          block: block,
                          isActive: isActive,
                          isCompleted: isCompleted,
                          remainingTime: isActive
                              ? _remainingTime
                              : Duration.zero,
                          totalTime: isActive ? _totalTime : Duration.zero,
                          onDone: isActive ? _completeCurrentBlock : null,
                          onSkip: isActive ? _skipCurrentBlock : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.progress,
    required this.completedCount,
    required this.remainingCount,
  });

  final double progress;
  final int completedCount;
  final int remainingCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          height: 3,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$completedCount done', style: theme.textTheme.labelSmall),
              Text('$remainingCount left', style: theme.textTheme.labelSmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayerBlockCard extends StatelessWidget {
  const _PlayerBlockCard({
    required this.block,
    required this.isActive,
    required this.isCompleted,
    required this.remainingTime,
    required this.totalTime,
    required this.onDone,
    required this.onSkip,
  });

  final WorkoutBlock block;
  final bool isActive;
  final bool isCompleted;

  final Duration remainingTime;
  final Duration totalTime;

  final VoidCallback? onDone;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = Color(block.accentColor);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.all(isActive ? 20 : 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(isActive ? 24 : 20),
        border: Border.all(
          color: isActive
              ? accent
              : theme.colorScheme.outline.withValues(alpha: 0.12),
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isActive ? 1 : 0.55,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BlockHeader(
              block: block,
              isActive: isActive,
              isCompleted: isCompleted,
            ),
            if (isActive) ...[
              const SizedBox(height: 24),
              _ActiveBlockContent(
                block: block,
                remainingTime: remainingTime,
                totalTime: totalTime,
                onDone: onDone!,
                onSkip: onSkip!,
                accent: accent,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BlockHeader extends StatelessWidget {
  const _BlockHeader({
    required this.block,
    required this.isActive,
    required this.isCompleted,
  });

  final WorkoutBlock block;
  final bool isActive;
  final bool isCompleted;

  String _typeLabel() {
    if (block is ExerciseBlock) {
      return 'Exercise — Reps';
    }

    if (block is TimerBlock) {
      return 'Exercise — Timer';
    }

    if (block is RestBlock) {
      return 'Rest';
    }

    return 'Block';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isActive ? '${_typeLabel()} · Active' : _typeLabel(),
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Color(block.accentColor),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                block.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (isCompleted)
          Icon(Icons.check_circle, color: Color(block.accentColor), size: 24),
      ],
    );
  }
}

class _ActiveBlockContent extends StatelessWidget {
  const _ActiveBlockContent({
    required this.block,
    required this.remainingTime,
    required this.totalTime,
    required this.onDone,
    required this.onSkip,
    required this.accent,
  });

  final WorkoutBlock block;

  final Duration remainingTime;
  final Duration totalTime;

  final VoidCallback onDone;
  final VoidCallback onSkip;

  final Color accent;

  @override
  Widget build(BuildContext context) {
    if (block is ExerciseBlock) {
      return _RepsContent(block: block as ExerciseBlock, onDone: onDone);
    }

    if (block is TimerBlock || block is RestBlock) {
      return _TimedContent(
        remainingTime: remainingTime,
        totalTime: totalTime,
        onDone: onDone,
        onSkip: onSkip,
        accent: accent,
      );
    }

    return const SizedBox.shrink();
  }
}

class _RepsContent extends StatelessWidget {
  const _RepsContent({required this.block, required this.onDone});

  final ExerciseBlock block;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Center(
          child: Text(
            '${block.repetitions} reps',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onDone,
            icon: const Icon(Icons.check),
            label: const Text('Done'),
          ),
        ),
      ],
    );
  }
}

class _TimedContent extends StatelessWidget {
  const _TimedContent({
    required this.remainingTime,
    required this.totalTime,
    required this.onDone,
    required this.onSkip,
    required this.accent,
  });

  final Duration remainingTime;
  final Duration totalTime;

  final VoidCallback onDone;
  final VoidCallback onSkip;

  final Color accent;

  double get progress {
    if (totalTime <= Duration.zero) {
      return 0;
    }

    final value = remainingTime.inMilliseconds / totalTime.inMilliseconds;

    return value.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          width: 190,
          height: 190,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 190,
                height: 190,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(accent),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Remaining', style: theme.textTheme.labelMedium),
                  const SizedBox(height: 4),
                  Text(
                    _formatDuration(remainingTime),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onDone,
            icon: const Icon(Icons.check),
            label: const Text('Mark Done'),
          ),
        ),
        const SizedBox(height: 4),
        TextButton(onPressed: onSkip, child: const Text('Skip →')),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final seconds = duration.inSeconds.ceil();
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainder.toString().padLeft(2, '0')}';
  }
}

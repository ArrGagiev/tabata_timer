import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tabata_timer/features/workout_builder/domain/models/workout_block.dart';
import 'package:tabata_timer/features/workout_builder/widgets/workout_block_card.dart';

class WorkoutBlocksList extends StatelessWidget {
  const WorkoutBlocksList({
    super.key,
    required this.blocks,
    required this.onReorder,
  });

  final List<WorkoutBlock> blocks;
  final void Function(int oldIndex, int newIndex) onReorder;

  @override
  Widget build(BuildContext context) {
    return SliverReorderableList(
      itemCount: blocks.length,
      onReorder: onReorder,
      proxyDecorator: _proxyDecorator,
      itemBuilder: (context, index) {
        final WorkoutBlock block = blocks[index];

        return ReorderableDelayedDragStartListener(
          key: ValueKey(block.id),
          index: index,
          child: WorkoutBlockCard(block: block),
        );
      },
    );
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final double animValue = Curves.easeInOut.transform(animation.value);

        final double scale = lerpDouble(1, 1.02, animValue)!;

        return Transform.scale(scale: scale, child: child);
      },
      child: child,
    );
  }
}

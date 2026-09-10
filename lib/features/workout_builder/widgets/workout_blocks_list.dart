import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tabata_timer/features/workout_builder/domain/models/workout_block.dart';
import 'package:tabata_timer/features/workout_builder/widgets/workout_block_card.dart';

class WorkoutBlocksList extends StatelessWidget {
  const WorkoutBlocksList({
    super.key,
    required this.blocks,
    required this.isEditing,
    required this.onReorder,
    required this.onEdit,
    required this.onDuplicate,
    required this.onChangeColor,
    required this.onDelete,
  });

  final List<WorkoutBlock> blocks;
  final bool isEditing;

  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(WorkoutBlock block) onEdit;
  final void Function(WorkoutBlock block) onDuplicate;
  final void Function(WorkoutBlock block) onChangeColor;
  final void Function(WorkoutBlock block) onDelete;

  @override
  Widget build(BuildContext context) {
    return SliverReorderableList(
      itemCount: blocks.length,
      onReorder: isEditing ? onReorder : (_, __) {},
      proxyDecorator: _proxyDecorator,
      itemBuilder: (context, index) {
        final WorkoutBlock block = blocks[index];

        return ReorderableDelayedDragStartListener(
          key: ValueKey(block.id),
          index: index,
          enabled: isEditing,
          child: WorkoutBlockCard(
            block: block,
            isEditing: isEditing,
            onEdit: () => onEdit(block),
            onDuplicate: () => onDuplicate(block),
            onChangeColor: () => onChangeColor(block),
            onDelete: () => onDelete(block),
          ),
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

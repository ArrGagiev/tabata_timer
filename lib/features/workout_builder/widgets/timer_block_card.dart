import 'package:flutter/material.dart';
import 'package:tabata_timer/features/workout_builder/domain/models/workout_block.dart';

class TimerBlockCard extends StatelessWidget {
  const TimerBlockCard({super.key, required this.block});

  final TimerBlock block;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 100,
        child: Center(
          child: Text('${block.title} — ${block.duration.inSeconds} sec'),
        ),
      ),
    );
  }
}

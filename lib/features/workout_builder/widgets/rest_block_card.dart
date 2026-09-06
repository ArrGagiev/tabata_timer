import 'package:flutter/material.dart';
import 'package:tabata_timer/features/workout_builder/domain/models/workout_block.dart';

class RestBlockCard extends StatelessWidget {
  const RestBlockCard({super.key, required this.block});

  final RestBlock block;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 70,
        child: Center(
          child: Text('${block.title} — ${block.duration.inSeconds} sec'),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

enum AddBlockType { exercise, timer, rest }

class AddBlockSheet extends StatelessWidget {
  const AddBlockSheet({super.key});

  static Future<AddBlockType?> show(BuildContext context) {
    return showModalBottomSheet<AddBlockType>(
      context: context,
      builder: (_) => const AddBlockSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AddBlockOption(
              icon: Icons.fitness_center,
              title: 'Exercise',
              type: AddBlockType.exercise,
            ),
            _AddBlockOption(
              icon: Icons.timer_outlined,
              title: 'Timer',
              type: AddBlockType.timer,
            ),
            _AddBlockOption(
              icon: Icons.self_improvement,
              title: 'Rest',
              type: AddBlockType.rest,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddBlockOption extends StatelessWidget {
  const _AddBlockOption({
    required this.icon,
    required this.title,
    required this.type,
  });

  final IconData icon;
  final String title;
  final AddBlockType type;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context, type);
      },
    );
  }
}

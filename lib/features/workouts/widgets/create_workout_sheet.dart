import 'package:flutter/material.dart';

class CreateWorkoutSheet extends StatefulWidget {
  const CreateWorkoutSheet({super.key});

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const CreateWorkoutSheet(),
    );
  }

  @override
  State<CreateWorkoutSheet> createState() => _CreateWorkoutSheetState();
}

class _CreateWorkoutSheetState extends State<CreateWorkoutSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _createWorkout() {
    final String title = _controller.text.trim();

    if (title.isEmpty) {
      return;
    }

    Navigator.pop(context, title);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('New Workout', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _createWorkout(),
              decoration: const InputDecoration(
                labelText: 'Workout name',
                hintText: 'Leg Day',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _createWorkout,
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}

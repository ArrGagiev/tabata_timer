import 'package:flutter/material.dart';

import '../../../core/widgets/bottom_sheet/app_bottom_sheet.dart';
import '../../../core/widgets/bottom_sheet/app_sheet_button.dart';
import '../../../core/widgets/bottom_sheet/app_text_field.dart';

class CreateWorkoutSheet extends StatefulWidget {
  const CreateWorkoutSheet({super.key});

  static Future<String?> show(BuildContext context) {
    return AppBottomSheet.show<String>(
      context: context,
      title: 'New Workout',
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _controller,
          label: 'Workout name',
          hintText: 'Leg Day',
          textInputAction: TextInputAction.done,
          autofocus: true,
        ),

        const SizedBox(height: 20),

        AppSheetButton(label: 'Create', onPressed: _createWorkout),
      ],
    );
  }
}

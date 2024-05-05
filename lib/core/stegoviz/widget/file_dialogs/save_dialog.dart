import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stego_viz/app/bloc/stego_session/stego_session_cubit.dart';


Future<T?> showSaveDialog<T>({required BuildContext context}) {
  return showDialog<T>(
    context: context,
    builder: (context) {
      return const SaveDialog();
    },
  );
}

class SaveDialog extends StatefulWidget {
  const SaveDialog({super.key});

  @override
  State<SaveDialog> createState() => _SaveDialogState();
}

class _SaveDialogState extends State<SaveDialog> {
  @override
  Widget build(BuildContext context) {
    final stegoSession = context.read<StegoSessionCubit>();
    final TextEditingController titleController = TextEditingController();

    final titleCopy = stegoSession.state.save.title;

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.save,
            size: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          const Text("Save Project"),
        ],
      ),
      // rounded corners of 10px
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      insetPadding: const EdgeInsets.all(16),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: _SaveDialogContent(titleController: titleController),
      ),
      actions: [
        TextButton(
          onPressed: () {
            stegoSession.updateTitle(titleCopy);
            Navigator.of(context).pop();
          },
          child: Text('cancel', style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 16.0)),
        ),
        BlocBuilder<StegoSessionCubit, StegoSessionState>(
          buildWhen: (previous, current) => previous.stegoImage != current.stegoImage,
          builder: (context, state) {
            return TextButton(
              onPressed: state.stegoImage.isEmpty ? null : () {
                stegoSession.saveSessionToStorage();
                Navigator.of(context).pop();
              },
              child: Text('save', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 18.0, fontWeight: FontWeight.bold)),
            );
          }
        ),
      ],
    );
  }
}

class _SaveDialogContent extends StatelessWidget {
  const _SaveDialogContent({
    required this.titleController,
  });

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Title',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<StegoSessionCubit, StegoSessionState>(
          buildWhen: (previous, current) => previous.save.title != current.save.title,
          builder: (context, state) {
            titleController.text = state.save.title;
            titleController.selection = TextSelection.fromPosition(TextPosition(offset: titleController.text.length));
            return TextField(
              controller: titleController,
              maxLength: 20,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
              ],
              onChanged: (value) {
                context.read<StegoSessionCubit>().updateTitle(value);
              },
              autocorrect: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a title',
              ),
            );
          }
        ),
      ],
    );
  }
}


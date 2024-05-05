import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stego_viz/shared/stegoviz_edu.dart';

import 'package:stego_viz/app/bloc/stego_session/stego_session_cubit.dart';
import 'message_edu_content.dart';

class MessageEditor extends StatelessWidget {
  const MessageEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Material(
      child: Padding(
        padding: const EdgeInsets.only(top: 12, left: 10, right: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MessageTextField(controller: controller),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 4, top: 4),
                  child: _MessageMetaData(),
                ),
                IconButton(
                  icon: Icon(
                    Icons.help_outline,
                    color: Theme.of(context).colorScheme.primary.withAlpha(150),
                  ),
                  onPressed: () {
                    showStegoVizEduDialog(
                      context: context,
                      title: 'Secret Message',
                      leading: Icon(
                        Icons.message,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: const SecretMessageEduContent(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}

class _MessageTextField extends StatelessWidget {
  const _MessageTextField({
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StegoSessionCubit, StegoSessionState>(
      builder: (context, state) {
        controller.text = state.save.secretMessage;
        return TextField(
          controller: controller,
          maxLines: null,
          textInputAction: TextInputAction.done,
          // make the default border color primary
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              // dark theme purple
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            focusedBorder: OutlineInputBorder(
              // dark theme purple
              borderSide: BorderSide(
                width: 2.0,
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            labelText: 'Secret Message',
            hintText: 'Enter your secret message',
            // make the border look like an outline
          ),
          onChanged: (value) {
            context.read<StegoSessionCubit>().updateSecretMessage(value);
          },
        );
      }
    );
  }
}

class _MessageMetaData extends StatelessWidget {
  const _MessageMetaData();

  @override
  Widget build(BuildContext context) {
    // column of how many characters and how many bytes in the message
    return BlocBuilder<StegoSessionCubit, StegoSessionState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _makeMetaDataText('Bytes', (state.save.secretMessage.codeUnits.length).toString()),
            _makeMetaDataText('Bits', (state.save.secretMessage.codeUnits.length*8).toString()),
          ],
        );
      },
    );
  }

  Text _makeMetaDataText(String label, String value) {
    return Text(
      '$label: $value',
      style: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }
}


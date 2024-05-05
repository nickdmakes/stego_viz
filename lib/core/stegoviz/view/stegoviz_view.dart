import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stego_viz/imutils.dart';
import 'package:stego_viz/app/bloc/stego_session/stego_session_cubit.dart';
import 'package:stego_viz/root_nav/root_nav.dart';

import '../widget/image_viewer/image_viewer.dart';
import '../widget/editors/message/message_editor.dart';
import '../widget/editors/color/color_editor.dart';
import '../widget/editors/embed/embed_editor.dart';

class StegoVizView extends StatelessWidget {
  const StegoVizView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocListener<StegoSessionCubit, StegoSessionState>(
      listenWhen: (previous, current) => previous.error != current.error,
      listener: (context, state) {
        if (state.error.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              // make the snackbar look like an error
              backgroundColor: Theme.of(context).colorScheme.error,
              content: Text(
                state.error,
                style: TextStyle(color: Theme.of(context).colorScheme.onError),
              ),
              duration: const Duration(seconds: 4),
            ),
          );
          context.read<StegoSessionCubit>().updateError('');
        }
      },
      child: SingleChildScrollView(
        // only scroll when the widgets exceed the screen height
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: screenHeight * 0.50,
              child: const ImageViewer(),
            ),
            BlocBuilder<RootNavCubit, RootNavState>(
              buildWhen: (previous, current) => previous.navIndex != current.navIndex,
              builder: (context, state) {
                if (state.navIndex == 0) {
                  return const MessageEditor();
                } else if (state.navIndex == 1) {
                  return const ColorEditor();
                } else if (state.navIndex == 2) {
                  return const EmbedEditor();
                } else {
                  return const MessageEditor();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

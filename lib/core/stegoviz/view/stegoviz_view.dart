import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stego_viz/root_nav/root_nav.dart';

import '../widget/image_viewer/image_viewer.dart';
import '../widget/editors/message_editor.dart';
import '../widget/editors/color_editor.dart';
import '../widget/editors/embed_editor.dart';

class StegoVizView extends StatelessWidget {
  const StegoVizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          flex: 3,
          child: ImageViewer(),
        ),
        Expanded(
          flex: 2,
          child: BlocBuilder<RootNavCubit, RootNavState>(
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
          )
        ),
      ],
    );
  }
}

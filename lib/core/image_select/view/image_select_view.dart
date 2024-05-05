import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stego_viz/imutils.dart';

import 'package:stegoviz_storage/stegoviz_storage.dart';

import 'package:stego_viz/core/stegoviz/stegoviz.dart';
import 'package:stego_viz/app/bloc/stego_session/stego_session_cubit.dart';
import 'package:stego_viz/core/image_select/cubit/image_select_cubit.dart';

import '../widget/image_select_card/image_select_card.dart';

class ImageSelectView extends StatelessWidget {
  const ImageSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageSelectCubit, ImageSelectState>(
      builder: (context, state) {
        final saves = state.stegoVizSaves;
        return _StegoVizSavesListView(saves: saves);
      }
    );
  }
}

class _StegoVizSavesListView extends StatelessWidget {
  const _StegoVizSavesListView({required this.saves});

  final List<StegoVizSave> saves;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: saves.length,
      itemBuilder: (context, index) {
        final save = saves[index];
        final imageWidth = getImageWidth(base64ToBytes(save.image)).toString();
        final imageHeight = getImageHeight(base64ToBytes(save.image)).toString();
        final imageSize = prettifyImageSize(save.image);
        return Column(
          children: [
            ImageSelectCard(
              title: save.title,
              subtitle: '${imageWidth}x$imageHeight - $imageSize',
              imageString: save.image,
              onDelete: (BuildContext _) {
                context.read<ImageSelectCubit>().removeStegoVizSave(save.id);
              },
              onSelect: () {
                context.read<StegoSessionCubit>().loadSaveToSession(save);
                context.read<StegoSessionCubit>().applySteganography();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const StegoVizPage()));
              },
            ),
            const SizedBox(height: 4),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stegoviz_storage/stegoviz_storage.dart';

import 'package:stego_viz/root_nav/root_nav.dart';
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
        return Column(
          children: [
            ImageSelectCard(
              title: save.id,
              subtitle: "${save.image!.length} bytes",
              imageString: save.image,
              onDelete: (BuildContext _) => context.read<ImageSelectCubit>().removeStegoVizSave(save.id),
              onSelect: () {
                context.read<StegoSessionCubit>().loadSaveToSession(save);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RootNavPage()));
              },
            ),
            const SizedBox(height: 4),
          ],
        );
      },
    );
  }
}

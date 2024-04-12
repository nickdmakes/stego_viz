import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stego_viz/core/image_select/cubit/image_select_cubit.dart';

import '../widget/image_select_card/image_select_card.dart';

class ImageSelectView extends StatelessWidget {
  const ImageSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(onPressed: () => context.read<ImageSelectCubit>().addTestSave(), icon: const Icon(Icons.add)),
        Expanded(
          child: BlocBuilder<ImageSelectCubit, ImageSelectState>(
            builder: (context, state) {
              final saves = state.stegoVizSaves;
              return ListView.builder(
                itemCount: saves.length,
                itemBuilder: (context, index) {
                  final save = saves[index];
                  return ImageSelectCard(
                    title: save.title,
                    subtitle: "${save.image!.length} bytes",
                    imageString: save.image,
                    onDelete: (BuildContext _) {
                      context.read<ImageSelectCubit>().removeStegoVizSave(save.id);
                    },
                  );
                },
              );
            }
          ),
        ),
      ],
    );
  }
}

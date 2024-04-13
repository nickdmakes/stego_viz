import 'dart:convert';
import 'package:image/image.dart' as img;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stego_viz/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:stego_viz/app/bloc/stego_session/stego_session_cubit.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({super.key});

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    final ImagePicker picker = ImagePicker();
    final stegoSessionCubit = context.read<StegoSessionCubit>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: BlocBuilder<StegoSessionCubit, StegoSessionState>(
            buildWhen: (previous, current) => previous.selectedImage != current.selectedImage,
            builder: (context, state) {
              final image = state.selectedImage;
              return image.isEmpty
                  ? const Text('No image selected')
                  : Stack(
                      children: [
                        Container(color: Colors.black54),
                        Center(
                          child: Image.memory(
                            base64ToBytes(image),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    );
              //     : Image.memory(
              //         base64ToBytes(image),
              //         fit: BoxFit.fill,
              // );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final XFile? image = await picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              final imageBytes = await image.readAsBytes();
              final base64Image = base64Encode(imageBytes);
              stegoSessionCubit.selectedImageChanged(base64Image);
            }
          },
          child: const Text('Select Image'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stego_viz/imutils.dart';

import 'bloc/image_viewer_bloc.dart';
import 'package:stego_viz/app/bloc/stego_session/stego_session_cubit.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({super.key});

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    final sessionCubit = context.read<StegoSessionCubit>();

    if(sessionCubit.state.status == StegoSessionStatus.processing) {
      context.read<ImageViewerBloc>().add(ImageViewerImageProcessingStarted());
    } else if(sessionCubit.state.stegoImage.isNotEmpty) {
      final imageBytes = base64ToBytes(sessionCubit.state.stegoImage);
      context.read<ImageViewerBloc>().add(ImageViewerDisplayImage(imageBytes));
    }

    return BlocListener<StegoSessionCubit, StegoSessionState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if(state.status == StegoSessionStatus.processing) {
          context.read<ImageViewerBloc>().add(ImageViewerImageProcessingStarted());
        } else if(state.stegoImage.isNotEmpty) {
          final imageBytes = base64ToBytes(state.stegoImage);
          context.read<ImageViewerBloc>().add(ImageViewerDisplayImage(imageBytes));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: BlocBuilder<ImageViewerBloc, ImageViewerState>(
              builder: (context, state) {
                if(state is ImageViewerChoosing) {
                  return const _ImageViewerLoadingMessage(message: 'Choosing Image...');
                } else if(state is ImageViewerConverting) {
                  return const _ImageViewerLoadingMessage(message: 'Converting to .png...');
                } else if(state is ImageViewerImageTooLarge) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showImageLargeDialog(context.read<ImageViewerBloc>(), state.imageBytes);
                  });
                  return const _ImageViewerLoadingMessage(message: 'Large Image...');
                } else if(state is ImageViewerResizing) {
                  return const _ImageViewerLoadingMessage(message: 'Resizing Image...');
                } else if(state is ImageViewerProcessing) {
                  return const _ImageViewerLoadingMessage(message: 'Processing Image...');
                } else if(state is ImageViewerSelected) {
                  sessionCubit.updateCoverImageWithBytes(state.imageBytes);
                  context.read<ImageViewerBloc>().add(ImageViewerDisplayImage(state.imageBytes));
                  return const _ImageViewerLoadingMessage(message: 'Displaying Image...');
                } else if(state is ImageViewerDisplaying) {
                  return const _ImageViewerImage();
                } else {
                  return Container(
                    color: Colors.black54,
                    child: Center(
                      child: _ImageSelectButton(
                        onPressed: () {
                          showImagePicker(context.read<ImageViewerBloc>(), sessionCubit);
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          const _ImageViewerMetadata(),
          _ImageViewerToolbar(
            onSelectImagePressed: () {
              showImagePicker(context.read<ImageViewerBloc>(), sessionCubit);
            },

          ),
        ],
      ),
    );
  }

  Future<void> showImagePicker(ImageViewerBloc imageViewerBloc, StegoSessionCubit stegoSessionCubit) async {
    final ImagePicker picker = ImagePicker();
    imageViewerBloc.add(ImageViewerSelectImageClicked());
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      stegoSessionCubit.updateStegoImageWithBase64("");
      final imageBytes = await image.readAsBytes();
      imageViewerBloc.add(ImageViewerSelectImagePicked(imageBytes, false));
    } else {
      if(stegoSessionCubit.state.stegoImage.isNotEmpty) {
        final imageBytes = base64ToBytes(stegoSessionCubit.state.stegoImage);
        imageViewerBloc.add(ImageViewerDisplayImage(imageBytes));
      } else {
        imageViewerBloc.add(ImageViewerSelectReset());
      }
    }
  }

  Future<dynamic> showImageLargeDialog(ImageViewerBloc imageViewerBloc, Uint8List imageBytes) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(highlightColor: Colors.transparent),
          child: AlertDialog(
            title: const Text('Large Image Detected'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Consider resizing the image to improve performance...'),
                const SizedBox(height: 8),
                Card(
                  margin: const EdgeInsets.only(top: 8, left: 0, right: 0, bottom: 0),
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    title: const Text('High Quality'),
                    subtitle: const Text('1024 pixel max side length'),
                    // make highlight transparent
                    onTap: () {
                      imageViewerBloc.add(ImageViewerResizeClicked(imageBytes, 1024));
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(top: 8, left: 0, right: 0, bottom: 0),
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    title: const Text('Medium Quality'),
                    subtitle: const Text('512 pixel max side length'),
                    onTap: () {
                      imageViewerBloc.add(ImageViewerResizeClicked(imageBytes, 512));
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(top: 8, left: 0, right: 0, bottom: 0),
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    title: const Text('Low Quality'),
                    subtitle: const Text('256 pixel max side length'),
                    onTap: () {
                      imageViewerBloc.add(ImageViewerResizeClicked(imageBytes, 256));
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  imageViewerBloc.add(ImageViewerSelectReset());
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  imageViewerBloc.add(ImageViewerSelectImagePicked(imageBytes, true));
                  Navigator.of(context).pop();
                },
                child: Text('Keep original', style: TextStyle(color: Colors.red[500])),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ImageViewerToolbar extends StatelessWidget {
  const _ImageViewerToolbar({
    required this.onSelectImagePressed,
  });

  final Function() onSelectImagePressed;

  @override
  Widget build(BuildContext context) {
    // Row of two buttons with space between
    return Card(
      margin: const EdgeInsets.all(0),
      // remove rounded corners
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              onPressed: onSelectImagePressed,
              child: const Text('Select Image'),
            ),
            BlocBuilder<StegoSessionCubit, StegoSessionState>(
              buildWhen: (previous, current) => previous.status != current.status,
              builder: (context, state) {
                final imageLoaded = state.stegoImage.isNotEmpty;
                final isDirty = state.status == StegoSessionStatus.dirty;
                return TextButton(
                  onPressed: imageLoaded && isDirty ? () {
                    context.read<StegoSessionCubit>().applySteganography();
                  } : null,
                  child: state.status == StegoSessionStatus.processing
                      ? const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()))
                      : const Text('Apply Changes'),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}


class _ImageViewerImage extends StatelessWidget {
  const _ImageViewerImage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StegoSessionCubit, StegoSessionState>(
      buildWhen: (previous, current) => previous.stegoImage != current.stegoImage
          || (current.status != StegoSessionStatus.dirty && previous.status != current.status),
      builder: (context, state) {
        if(state.status == StegoSessionStatus.processing) {
          return const _ImageViewerLoadingMessage(message: 'Processing Image...');
        } else if(state.stegoImage.isEmpty) {
          return const _ImageViewerLoadingMessage(message: 'Displaying Image...');
        } else {
          return PhotoView(
            // when zooming, the image will not go beyond its original size
            imageProvider: Image.memory(base64ToBytes(state.stegoImage)).image,
            backgroundDecoration: const BoxDecoration(color: Colors.black54),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        }
      }
    );
  }
}

class _ImageViewerMetadata extends StatelessWidget {
  const _ImageViewerMetadata();

  @override
  Widget build(BuildContext context) {
    // row with black45 background
    return Container(
      color: Colors.black45,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            BlocBuilder<StegoSessionCubit, StegoSessionState>(
              buildWhen: (previous, current) => previous.stegoImage != current.stegoImage,
              builder: (context, state) {
                var imageWidth = 0;
                var imageHeight = 0;
                if(state.stegoImage != "") {
                  imageWidth = getImageWidth(base64ToBytes(state.stegoImage));
                  imageHeight = getImageHeight(base64ToBytes(state.stegoImage));
                }
                return Text(
                  state.stegoImage.isEmpty ? '' : '$imageWidth x $imageHeight',
                  style: const TextStyle(color: Colors.white),
                );
              },
            ),
            BlocBuilder<StegoSessionCubit, StegoSessionState>(
              buildWhen: (previous, current) => previous.stegoImage != current.stegoImage,
              builder: (context, state) {
                var imageSize = "";
                if(state.stegoImage != "") {
                  imageSize = prettifyImageSize(state.stegoImage);
                }
                return Text(
                  state.stegoImage.isEmpty ? '' : imageSize,
                  style: const TextStyle(color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class _ImageSelectButton extends StatelessWidget {
  const _ImageSelectButton({
    required this.onPressed,
  });

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      child: const Text('Select Image'),
    );
  }
}

class _ImageViewerLoadingMessage extends StatelessWidget {
  const _ImageViewerLoadingMessage({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.black54,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              Text(message),
            ],
          ),
        ],
      ),
    );
  }
}


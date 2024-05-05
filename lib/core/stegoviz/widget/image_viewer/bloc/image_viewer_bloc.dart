import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:stego_viz/imutils.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'image_viewer_event.dart';
part 'image_viewer_state.dart';

class ImageViewerBloc extends Bloc<ImageViewerEvent, ImageViewerState> {
  ImageViewerBloc() : super(ImageViewerInitial()) {
    on<ImageViewerSelectImageClicked>(_onImageViewerSelectImageClicked);
    on<ImageViewerSelectImagePicked>(_onImageViewerSelectImagePicked);
    on<ImageViewerResizeClicked>(_onImageViewerResizeClicked);
    on<ImageViewerSelectReset>(_onImageViewerSelectReset);
    on<ImageViewerDisplayImage>(_onImageViewerDisplayImage);
    on<ImageViewerImageProcessingStarted>(_onImageViewerImageProcessingStarted);
  }

  void _onImageViewerSelectImageClicked(ImageViewerSelectImageClicked event, Emitter<ImageViewerState> emit) async {
    emit(ImageViewerChoosing());
  }

  void _onImageViewerDisplayImage(ImageViewerDisplayImage event, Emitter<ImageViewerState> emit) async {
    emit(ImageViewerDisplaying(event.imageBytes));
  }

  Future<void> _onImageViewerSelectImagePicked(ImageViewerSelectImagePicked event, Emitter<ImageViewerState> emit) async {
    emit(ImageViewerConverting());
    final pngBytes = await compute(reformatForStegoViz, event.imageBytes);
    if(event.keepOriginal) {
      emit(ImageViewerSelected(pngBytes));
      return;
    }
    // if the image is more than 1MB, resize it
    if(pngBytes.lengthInBytes > 1024 * 1024) {
      emit(ImageViewerImageTooLarge(event.imageBytes));
    } else {
      emit(ImageViewerSelected(event.imageBytes));
    }
  }

  void _onImageViewerResizeClicked(ImageViewerResizeClicked event, Emitter<ImageViewerState> emit) async {
    emit(ImageViewerResizing());
    final resizedBytes = await compute(compressAndResizeImage, CompressAndResizeImageParams(event.imageBytes, event.longestSide));
    emit(ImageViewerSelected(resizedBytes));
  }

  void _onImageViewerSelectReset(ImageViewerSelectReset event, Emitter<ImageViewerState> emit) async {
    emit(ImageViewerInitial());
  }

  void _onImageViewerImageProcessingStarted(ImageViewerImageProcessingStarted event, Emitter<ImageViewerState> emit) async {
    emit(ImageViewerProcessing());
  }
}

part of 'image_viewer_bloc.dart';

abstract class ImageViewerEvent extends Equatable {
  const ImageViewerEvent();

  @override
  List<Object> get props => [];
}

class ImageViewerDisplayImage extends ImageViewerEvent {
  const ImageViewerDisplayImage(
    this.imageBytes,
  );

  final Uint8List imageBytes;

  @override
  List<Object> get props => [imageBytes];
}

class ImageViewerSelectImageClicked extends ImageViewerEvent {}

class ImageViewerResizeClicked extends ImageViewerEvent {
  const ImageViewerResizeClicked(
    this.imageBytes,
    this.longestSide,
  );

  final Uint8List imageBytes;
  final int longestSide;

  @override
  List<Object> get props => [imageBytes, longestSide];

}

class ImageViewerSelectImagePicked extends ImageViewerEvent {
  const ImageViewerSelectImagePicked(
    this.imageBytes,
    this.keepOriginal,
  );

  final Uint8List imageBytes;
  final bool keepOriginal;

  @override
  List<Object> get props => [imageBytes, keepOriginal];
}

class ImageViewerImageProcessingStarted extends ImageViewerEvent {}

class ImageViewerSelectReset extends ImageViewerEvent {}

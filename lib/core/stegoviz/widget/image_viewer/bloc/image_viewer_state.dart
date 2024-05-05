part of 'image_viewer_bloc.dart';

abstract class ImageViewerState extends Equatable {
  const ImageViewerState();

  @override
  List<Object> get props => [];
}

class ImageViewerInitial extends ImageViewerState {}

class ImageViewerChoosing extends ImageViewerState {}

class ImageViewerConverting extends ImageViewerState {}

class ImageViewerImageTooLarge extends ImageViewerState {
  final Uint8List imageBytes;

  const ImageViewerImageTooLarge(this.imageBytes);

  @override
  List<Object> get props => [imageBytes];
}

class ImageViewerResizing extends ImageViewerState {}

class ImageViewerSelected extends ImageViewerState {
  final Uint8List imageBytes;

  const ImageViewerSelected(this.imageBytes);

  @override
  List<Object> get props => [imageBytes];
}

class ImageViewerProcessing extends ImageViewerState {}

class ImageViewerDisplaying extends ImageViewerState {
  final Uint8List imageBytes;

  const ImageViewerDisplaying(this.imageBytes);

  @override
  List<Object> get props => [imageBytes];
}

class ImageViewerError extends ImageViewerState {
  final String message;

  const ImageViewerError(this.message);

  @override
  List<Object> get props => [message];
}

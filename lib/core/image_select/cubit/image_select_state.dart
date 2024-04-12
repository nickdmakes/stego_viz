part of 'image_select_cubit.dart';

class ImageSelectState extends Equatable {
  const ImageSelectState({
    this.stegoVizSaves = const [],
  });

  final List<StegoVizSave> stegoVizSaves;

  @override
  List<Object> get props => [stegoVizSaves];

  ImageSelectState copyWith({
    List<StegoVizSave>? stegoVizSaves,
  }) {
    return ImageSelectState(
      stegoVizSaves: stegoVizSaves ?? this.stegoVizSaves,
    );
  }
}

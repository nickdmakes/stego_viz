part of 'stego_session_cubit.dart';

class StegoSessionState extends Equatable {
  const StegoSessionState({
    this.id = "",
    this.selectedImage = "",
  });

  final String id;
  // The selected image: a base64 string. Empty string if no image is selected.
  final String selectedImage;

  @override
  List<Object> get props => [id, selectedImage];

  StegoSessionState copyWith({
    String? id,
    String? selectedImage,
  }) {
    return StegoSessionState(
      id: id ?? this.id,
      selectedImage: selectedImage ?? this.selectedImage,
    );
  }
}

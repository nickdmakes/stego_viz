part of 'stego_session_cubit.dart';

enum StegoSessionStatus {
  dirty, // changes have been made
  processing, // changes are being applied
  exporting, // stego image is being exported
  clean, // changes have been applied
}

class StegoSessionState extends Equatable {
  const StegoSessionState({
    this.save = const StegoVizSave(),
    this.stegoImage = "",
    this.status = StegoSessionStatus.clean,
    this.error = "",
  });

  final StegoVizSave save;
  final String stegoImage;
  final StegoSessionStatus status;
  final String error;

  @override
  List<Object> get props => [save, stegoImage, status, error];

  StegoSessionState copyWith({
    StegoVizSave? save,
    String? stegoImage,
    StegoSessionStatus? status,
    String? error,
  }) {
    return StegoSessionState(
      save: save ?? this.save,
      stegoImage: stegoImage ?? this.stegoImage,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

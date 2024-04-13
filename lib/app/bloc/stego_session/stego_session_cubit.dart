import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stegoviz_storage/stegoviz_storage.dart';

part 'stego_session_state.dart';

class StegoSessionCubit extends Cubit<StegoSessionState> {
  StegoSessionCubit({
    required StegoVizStorage stegovizStorage,
  }) : _stegovizStorage = stegovizStorage,
        super(const StegoSessionState());

  final StegoVizStorage _stegovizStorage;

  /// Clear the session
  void clearSession() {
    emit(const StegoSessionState());
  }

  /// Functions that change the individual fields of the session
  void selectedImageChanged(String image) {
    emit(
      state.copyWith(
        selectedImage: image,
      ),
    );
  }

  /// Functions that save and load the session to and from the storage
  void loadSaveToSession(StegoVizSave save) {
    // port over a save to the session
    emit(
      state.copyWith(
        id: save.id,
        selectedImage: save.image,
      ),
    );
  }

  void saveSessionToStorage() async {
    // save the session to the storage
    final id = await _stegovizStorage.saveStegoVizSave(
      StegoVizSave(
        id: state.id,
        title: 'Session Save',
        image: state.selectedImage,
      ),
    );
    emit(state.copyWith(id: id));
  }
}

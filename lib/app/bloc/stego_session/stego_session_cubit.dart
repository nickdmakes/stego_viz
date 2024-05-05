import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:stego_viz/imutils.dart';
import 'package:stego_viz/stegoutils.dart';

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
  void updateCoverImageWithBytes(Uint8List imageBytes) async {
    final base64Image = await compute(bytesToBase64, imageBytes);
    emit(state.copyWith(save: state.save.copyWith(image: base64Image), stegoImage: base64Image));
  }

  void updateCoverImageWithBase64(String base64Image) {
    emit(state.copyWith(save: state.save.copyWith(image: base64Image), stegoImage: base64Image));
  }

  void updateStegoImageWithBytes(Uint8List imageBytes) async {
    final base64Image = await compute(bytesToBase64, imageBytes);
    emit(state.copyWith(stegoImage: base64Image));
  }

  void updateStegoImageWithBase64(String base64Image) {
    emit(state.copyWith(stegoImage: base64Image));
  }

  void updateSecretMessage(String secretMessage) {
    emit(state.copyWith(save: state.save.copyWith(secretMessage: secretMessage), status: StegoSessionStatus.dirty));
  }

  void updateTitle(String title) {
    emit(state.copyWith(save: state.save.copyWith(title: title), status: StegoSessionStatus.dirty));
  }

  void updateColor(StegoImageColor color) {
    emit(
      state.copyWith(
        save: state.save.copyWith(color: color),
        status: StegoSessionStatus.dirty,
      ),
    );
  }

  void updateEmbeddingMethod(StegoEmbeddingMethod method) {
    emit(
      state.copyWith(
        save: state.save.copyWith(method: method),
        status: StegoSessionStatus.dirty,
      ),
    );
  }

  void updateBitPlane(int bitPlane) {
    emit(
      state.copyWith(
        save: state.save.copyWith(bitPlane: bitPlane),
        status: StegoSessionStatus.dirty,
      ),
    );
  }

  void updateError(String error) {
    emit(state.copyWith(error: error));
  }

  /// Functions that save and load the session to and from the storage
  void loadSaveToSession(StegoVizSave save) {
    emit(state.copyWith(save: save));
  }

  void saveSessionToStorage() async {
    final id = await _stegovizStorage.saveStegoVizSave(state.save);
    emit(state.copyWith(save: state.save.copyWith(id: id)));
  }

  Future<void> exportImageToLibrary() async {
    final statusCopy = state.status;
    emit(state.copyWith(status: StegoSessionStatus.exporting));
    try {
      final imageBytes = await compute(base64ToBytes, state.stegoImage);
      await ImageGallerySaver.saveImage(imageBytes, quality: 100);
    } catch (e) {
      print(e);
      emit(state.copyWith(error: 'Export error'));
    }
    emit(state.copyWith(status: statusCopy));
  }

  /// Functions that run the steganography process
  void applySteganography() async {
    emit(state.copyWith(status: StegoSessionStatus.processing));
    try {
      var imageBytes = base64ToBytes(state.save.image);
      if(state.save.color == StegoImageColor.gray) {
        var gray = await compute(grayscaleImage, imageBytes);
        if(state.save.secretMessage.isNotEmpty) {
          final embedArguments = LsbEmbedArguments(gray, state.save.secretMessage, 8 - state.save.bitPlane);
          gray = await compute(lsbEmbedGray, embedArguments);
        }
        String grayImage = bytesToBase64(gray);
        emit(state.copyWith(
          stegoImage: grayImage,
          status: StegoSessionStatus.clean,
        ));
      } else {
        if(state.save.secretMessage.isNotEmpty) {
          final embedArguments = LsbEmbedArguments(imageBytes, state.save.secretMessage, 8 - state.save.bitPlane);
          imageBytes = await compute(lsbEmbedRGB, embedArguments);
        }
        emit(state.copyWith(
          stegoImage: bytesToBase64(imageBytes),
          status: StegoSessionStatus.clean,
        ));
      }
    } on StegoUtilsException catch (e) {
      emit(state.copyWith(error: e.message));
      emit(state.copyWith(status: StegoSessionStatus.dirty));
      return;
    } catch (e) {
      emit(state.copyWith(error: 'There was an error...'));
      emit(state.copyWith(status: StegoSessionStatus.dirty));
      return;
    }
  }
}

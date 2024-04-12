import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stegoviz_storage/stegoviz_storage.dart';

part 'image_select_state.dart';

class ImageSelectCubit extends Cubit<ImageSelectState> {
  ImageSelectCubit({required StegoVizStorage stegoVizStorage})
      : _stegovizStorage = stegoVizStorage,
        super(const ImageSelectState()) {
    _stegoVizSaveSubscription = _stegovizStorage.stegoVizSavesStream.listen(_imageSavesUpdated);
  }

  final StegoVizStorage _stegovizStorage;
  late final StreamSubscription<List<StegoVizSave>> _stegoVizSaveSubscription;

  // Function that turns an asset image into a base64 byte string
  Future<String> _imageToBase64(String path) async {
    final bytes = await rootBundle.load(path);
    return base64Encode(Uint8List.view(bytes.buffer));
  }

  void addTestSave() async {
    final testSave = StegoVizSave(
      id: '1',
      title: 'Test Save',
      image: await _imageToBase64('assets/images/image_placeholder.png')
    );
    saveStegoVizSave(testSave);
  }

  void _imageSavesUpdated(List<StegoVizSave> saves) {
    emit(state.copyWith(stegoVizSaves: saves));
  }

  void saveStegoVizSave(StegoVizSave save) {
    _stegovizStorage.saveStegoVizSave(save);
  }

  void removeStegoVizSave(String id) {
    _stegovizStorage.removeStegoVizSave(id);
  }

  @override
  Future<void> close() {
    _stegoVizSaveSubscription.cancel();
    return super.close();
  }
}
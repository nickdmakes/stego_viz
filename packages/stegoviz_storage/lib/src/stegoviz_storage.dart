import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'storage_keys.dart';
import 'save_objects/stegoviz_save.dart';

/// {@template stegoviz_storage}
/// storage repository which exposes an api for storing data to the devices disk
/// {@endtemplate}
class StegoVizStorage {
  /// {@macro stegoviz_storage}
  StegoVizStorage({
    required SharedPreferences? sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  final SharedPreferences? _sharedPreferences;

  /// Returns a list of steogviz saves from storage
  /// If no saves are found, returns an empty list
  List<StegoVizSave> getStegoVizSaves() {
    final List<String>? stegoVizSaves = _sharedPreferences!.getStringList(storageKeys[1]);
    if(stegoVizSaves != null) {
      return stegoVizSaves.map((e) => StegoVizSave.fromJson(jsonDecode(e))).toList();
    } else {
      return [];
    }
  }

  /// Save a StegoVizSave object to storage
  /// If the save already exists, it will be overwritten
  /// If the save does not exist, it will be added to the list
  /// Returns true if save was successful
  Future<bool> saveStegoVizSave(StegoVizSave save) async {
    final List<StegoVizSave> stegoVizSaves = getStegoVizSaves();
    final List<String> saveStrings = stegoVizSaves.map((e) => jsonEncode(e.toJson())).toList();
    final String saveString = jsonEncode(save.toJson());
    final id = save.id;
    final index = stegoVizSaves.indexWhere((element) => element.id == id);
    if(index != -1) {
      saveStrings[index] = saveString;
    } else {
      saveStrings.add(saveString);
    }
    return await _sharedPreferences!.setStringList(storageKeys[1], saveStrings);
  }

  /// Removes a StegoVizSave object from storage
  /// Returns true if save was removed
  Future<bool> removeStegoVizSave(String id) async {
    final List<StegoVizSave> stegoVizSaves = getStegoVizSaves();
    final List<String> saveStrings = stegoVizSaves.map((e) => jsonEncode(e.toJson())).toList();
    final index = stegoVizSaves.indexWhere((element) => element.id == id);
    if(index != -1) {
      saveStrings.removeAt(index);
      return await _sharedPreferences!.setStringList(storageKeys[1], saveStrings);
    } else {
      return false;
    }
  }

  /// Returns false if user has tried to authenticate yet
  /// Otherwise returns true and sets storage value to true
  Future<bool> firstTimeUser() async {
    if(_sharedPreferences!.getBool(storageKeys[0]) != null) {
      await _sharedPreferences.setBool(storageKeys[0], true);
      return true;
    } else {
      return false;
    }
  }
}

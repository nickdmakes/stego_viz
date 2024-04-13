import 'package:json_annotation/json_annotation.dart';

part 'stegoviz_save.g.dart';

/// {@template stegoviz_save}
/// A class which holds the title and image data of a StegoVizSave object
/// {@endtemplate}
@JsonSerializable()
class StegoVizSave {
  StegoVizSave({
    required this.id,
    this.title,
    this.image,
  });

  String id;
  final String? title;
  // base64 byte string
  final String? image;

  factory StegoVizSave.fromJson(Map<String, dynamic> json) => _$StegoVizSaveFromJson(json);
  Map<String, dynamic> toJson() => _$StegoVizSaveToJson(this);

  @override
  String toString() {
    return 'StegoVizSave{id: $id, title: $title, image: $image}';
  }
}

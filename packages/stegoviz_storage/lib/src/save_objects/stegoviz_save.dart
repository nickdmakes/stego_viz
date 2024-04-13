import 'package:json_annotation/json_annotation.dart';

part 'stegoviz_save.g.dart';

/// {@template stegoviz_save}
/// A class which holds the title and image data of a StegoVizSave object
/// {@endtemplate}
@JsonSerializable()
class StegoVizSave {
  const StegoVizSave({
    this.id = '',
    this.title = '',
    this.image = '',
  });

  final String id;
  final String title;
  // base64 byte string
  final String image;

  factory StegoVizSave.fromJson(Map<String, dynamic> json) => _$StegoVizSaveFromJson(json);
  Map<String, dynamic> toJson() => _$StegoVizSaveToJson(this);

  StegoVizSave copyWith({
    String? id,
    String? title,
    String? image,
  }) {
    return StegoVizSave(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
    );
  }

  @override
  String toString() {
    return 'StegoVizSave{id: $id, title: $title, image: $image}';
  }
}

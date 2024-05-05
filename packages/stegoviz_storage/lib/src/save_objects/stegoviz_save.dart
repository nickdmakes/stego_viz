import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'stegoviz_save.g.dart';

enum StegoImageColor {
  rgb, // red, green, blue
  gray, // black and white
}

enum StegoEmbeddingMethod {
  lsb, // least significant bit
  dct, // discrete cosine transform
}

/// {@template stegoviz_save}
/// A class which holds the title and image data of a StegoVizSave object
/// {@endtemplate}
@JsonSerializable()
class StegoVizSave extends Equatable {
  const StegoVizSave({
    this.id = '',
    this.lastSaved = '',
    this.title = '',
    this.image = '',
    this.secretMessage = '',
    this.color = StegoImageColor.rgb,
    this.method = StegoEmbeddingMethod.lsb,
    this.bitPlane = 1,
  });

  final String id;
  final String lastSaved;
  final String title;
  final String image;
  final String secretMessage;
  final StegoImageColor color;
  final StegoEmbeddingMethod method;
  final int bitPlane;

  factory StegoVizSave.fromJson(Map<String, dynamic> json) => _$StegoVizSaveFromJson(json);
  Map<String, dynamic> toJson() => _$StegoVizSaveToJson(this);

  StegoVizSave copyWith({
    String? id,
    String? lastSaved,
    String? title,
    String? image,
    String? secretMessage,
    StegoImageColor? color,
    StegoEmbeddingMethod? method,
    int? bitPlane,
  }) {
    return StegoVizSave(
      id: id ?? this.id,
      lastSaved: lastSaved ?? this.lastSaved,
      title: title ?? this.title,
      image: image ?? this.image,
      secretMessage: secretMessage ?? this.secretMessage,
      color: color ?? this.color,
      method: method ?? this.method,
      bitPlane: bitPlane ?? this.bitPlane,
    );
  }

  @override
  String toString() {
    return 'StegoVizSave{id: $id, title: $title, image: $image, secretMessage: $secretMessage, color: $color, method: $method}';
  }

  @override
  List<Object?> get props => [id, lastSaved, title, image, secretMessage, color, method, bitPlane];
}

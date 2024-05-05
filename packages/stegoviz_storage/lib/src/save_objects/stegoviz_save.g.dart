// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stegoviz_save.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StegoVizSave _$StegoVizSaveFromJson(Map<String, dynamic> json) => StegoVizSave(
      id: json['id'] as String? ?? '',
      lastSaved: json['lastSaved'] as String? ?? '',
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      secretMessage: json['secretMessage'] as String? ?? '',
      color: $enumDecodeNullable(_$StegoImageColorEnumMap, json['color']) ??
          StegoImageColor.rgb,
      method:
          $enumDecodeNullable(_$StegoEmbeddingMethodEnumMap, json['method']) ??
              StegoEmbeddingMethod.lsb,
      bitPlane: json['bitPlane'] as int? ?? 1,
    );

Map<String, dynamic> _$StegoVizSaveToJson(StegoVizSave instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lastSaved': instance.lastSaved,
      'title': instance.title,
      'image': instance.image,
      'secretMessage': instance.secretMessage,
      'color': _$StegoImageColorEnumMap[instance.color]!,
      'method': _$StegoEmbeddingMethodEnumMap[instance.method]!,
      'bitPlane': instance.bitPlane,
    };

const _$StegoImageColorEnumMap = {
  StegoImageColor.rgb: 'rgb',
  StegoImageColor.gray: 'gray',
};

const _$StegoEmbeddingMethodEnumMap = {
  StegoEmbeddingMethod.lsb: 'lsb',
  StegoEmbeddingMethod.dct: 'dct',
};

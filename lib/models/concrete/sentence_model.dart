import 'package:json_annotation/json_annotation.dart';

import '/models/abstract/i_base_model.dart';

/// Created by Yunus Emre Yıldırım
/// on 24.08.2022

part 'sentence_model.g.dart';

@JsonSerializable()
class SentenceModel implements IBaseModel {
  String? id;
  String title;
  String content;

  SentenceModel({required this.id, required this.title, required this.content});

  SentenceModel.withoutId({required this.title, required this.content});

  factory SentenceModel.fromJson(Map<String, dynamic> json) => _$SentenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SentenceModelToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:lugat_admin/models/abstract/i_base_model.dart';

/// Created by Yunus Emre Yıldırım
/// on 24.08.2022

part 'sentence_model.g.dart';

@JsonSerializable()
class SentenceModel extends IBaseModel {
  String id;
  String title;
  String content;
  int isRating;

  SentenceModel({required this.id, required this.title, required this.content, required this.isRating});

  factory SentenceModel.fromJson(Map<String, dynamic> json) => _$SentenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SentenceModelToJson(this);
}

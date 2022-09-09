import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lugat_admin/models/concrete/sentence_model.dart';

import '../main.dart';

/// Created by Yunus Emre Yıldırım
/// on 27.08.2022

class MainController extends GetxController {
  final sentenceList = <SentenceModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    for (QueryDocumentSnapshot<Map<String, dynamic>> item in sentenceCollection.docs) {
      sentenceList.add(SentenceModel.fromJson(item.data()));
    }
  }

  void updateSentence(SentenceModel model) {
    int indexModel = sentenceList.indexOf(model);

    sentenceList[indexModel] = model;
  }
}

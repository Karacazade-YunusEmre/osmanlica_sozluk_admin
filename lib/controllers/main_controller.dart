import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lugat_admin/models/concrete/sentence_model.dart';

import '../main.dart';

/// Created by Yunus Emre Yıldırım
/// on 27.08.2022

class MainController extends GetxController {
  final sentenceList = <SentenceModel>[].obs;
  List<SentenceModel> allSentenceList = [];

  @override
  Future<void> onInit() async {
    super.onInit();

    for (QueryDocumentSnapshot<Map<String, dynamic>> item in sentenceCollection.docs) {
      allSentenceList.add(SentenceModel.fromJson(item.data()));
    }
    sentenceList.value = allSentenceList;
  }

  void updateSentence(SentenceModel model) {
    int indexModel = sentenceList.indexOf(model);

    sentenceList[indexModel] = model;
  }

  void searchSentence(String query) {
    List<SentenceModel> filteredList = [];
    if (query.isEmpty) {
      filteredList = allSentenceList;
    } else {
      filteredList = [];
      filteredList = allSentenceList.where((element) => removeUnAlphanumericCharacters(element.title).contains(removeUnAlphanumericCharacters(query))).toList();
    }
    sentenceList.value = filteredList;
  }

  String removeUnAlphanumericCharacters(String str) {
    List<String> tempCharacters = [];
    RegExp regexCoTitle = RegExp(r'[a-zA-Z0-9öçşığüÖÇŞIĞÜ]+', multiLine: true);
    Iterable<RegExpMatch> matches = regexCoTitle.allMatches(str.toLowerCase());

    for (RegExpMatch item in matches) {
      tempCharacters.add(item[0]!.toLowerCase());
    }

    return tempCharacters.join();
  }
}

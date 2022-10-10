import 'package:get/get.dart';

import '/models/concrete/sentence_model.dart';
import '/utilities/string_extensions.dart';
import '../main.dart';

/// Created by Yunus Emre Yıldırım
/// on 27.08.2022

class MainController extends GetxController {
  final fixedSentenceList = <SentenceModel>[];

  final sentenceList = <SentenceModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    await setupSentenceList();
  }

  ///#region setup methods

  Future<void> setupSentenceList() async {
    List<SentenceModel>? tempSentenceList = await serviceStorage.getAll();

    if (tempSentenceList != null && tempSentenceList.isNotEmpty) {
      fixedSentenceList.addAll(tempSentenceList);
      sentenceList.addAll(fixedSentenceList);
    }
  }

  ///#endregion setup methods

  ///#region event methods

  Future<void> addSentence({required String title, required String content}) async {
    SentenceModel sentenceModel = SentenceModel.withoutId(title: title, content: content);

    String? serviceId = await serviceStorage.add(sentenceModel);
    sentenceModel.id = serviceId;

    sentenceList.add(sentenceModel);
    fixedSentenceList.add(sentenceModel);
  }

  void updateSentence({required SentenceModel currentModel, required String title, required String content}) async {
    int indexSentenceList = sentenceList.indexOf(currentModel);
    int indexFixedSentenceList = fixedSentenceList.indexOf(currentModel);

    currentModel.title = title;
    currentModel.content = content;

    serviceStorage.update(currentModel);
    sentenceList[indexSentenceList] = currentModel;
    fixedSentenceList[indexFixedSentenceList] = currentModel;
  }

  void deleteSentence({required SentenceModel currentSentence}) {
    sentenceList.remove(currentSentence);
    fixedSentenceList.remove(currentSentence);
    serviceStorage.delete(currentSentence);
  }

  void searchSentence(String query) {
    List<SentenceModel> filteredList = [];
    if (query.isEmpty) {
      filteredList = fixedSentenceList;
    } else {
      filteredList.clear();
      filteredList = fixedSentenceList.where((element) => element.title.removeUnAlphanumericCharacters.contains(query.removeUnAlphanumericCharacters)).toList();
    }
    sentenceList.clear();
    sentenceList.value = filteredList;
  }

  ///#endregion event methods

  ///#region general purpose methods

  void loadSentenceListAsDefault() {
    sentenceList.clear();
    sentenceList.addAll(fixedSentenceList);
  }

  ///#endregion general purpose methods

}

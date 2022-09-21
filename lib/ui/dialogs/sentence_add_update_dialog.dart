import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lugat_admin/main.dart';

import '../../controllers/main_controller.dart';
import '../../models/concrete/sentence_model.dart';

/// Created by Yunus Emre Yıldırım
/// on 12.09.2022

class SentenceAddUpdateDialog {
  final formKey = GlobalKey<FormState>();

  final SentenceModel? currentSentence;

  late TextEditingController textControllerTitle;

  late TextEditingController textControllerContent;
  late MainController mainController;

  String title = '';
  String content = '';

  SentenceAddUpdateDialog({required this.currentSentence}) {
    textControllerTitle = TextEditingController(text: currentSentence != null ? currentSentence!.title : '');
    textControllerContent = TextEditingController(text: currentSentence != null ? currentSentence!.content : '');
    mainController = Get.find();

    showSentenceAddDialog;
  }

  void get showSentenceAddDialog {
    Get.defaultDialog(
      title: currentSentence != null ? 'Cümleyi Güncelleyin' : 'Cümle Ekleyin',
      titleStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      content: SizedBox(
        width: 400,
        height: 200,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormField(
                controller: textControllerTitle,
                autofocus: true,
                decoration: const InputDecoration(
                  label: Text('Başlık'),
                  hintText: 'Başlık girin',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                validator: (String? value) => value!.isEmpty ? 'Başlık alanı boş bırakılamaz' : null,
                onSaved: (String? value) => title = value!,
              ),
              TextFormField(
                controller: textControllerContent,
                decoration: const InputDecoration(
                  label: Text('İçerik'),
                  hintText: 'İçerik girin',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                validator: (String? value) => value!.isEmpty ? 'İçerik alanı boş bırakılamaz' : null,
                onSaved: (String? value) => content = value!,
              ),
              Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        /// for update sentence
                        if (currentSentence != null) {
                          int index = mainController.sentenceList.indexOf(currentSentence!);

                          currentSentence!.title = title;
                          currentSentence!.content = content;

                          fireStore.doc('Sentence/${currentSentence!.id}').update(currentSentence!.toJson());
                          mainController.sentenceList[index] = currentSentence!;
                        }

                        /// for add sentence
                        else {
                          try {
                            String id = fireStore.collection('Sentence').doc().id;
                            SentenceModel sentence = SentenceModel(id: id, title: title, content: content, isRating: 0);
                            fireStore.doc('Sentence/$id').set(sentence.toJson());
                            mainController.sentenceList.add(sentence);
                          } catch (e) {
                            debugPrint('Hata oluştu. ${e.toString()}');
                          }
                        }
                        textControllerTitle.clear();
                        textControllerContent.clear();
                        Get.back();
                        Get.snackbar(
                          'BİLGİ',
                          currentSentence == null ? 'Cümle başarıyla kaydedildi.' : 'Cümle başarıyla güncellendi',
                          borderColor: Colors.green,
                          borderWidth: 2,
                          snackPosition: SnackPosition.BOTTOM,
                          maxWidth: MediaQuery.of(context).size.width * 0.4,
                        );
                      }
                    },
                    child: Text(currentSentence != null ? 'Güncelle' : 'KAYDET'),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

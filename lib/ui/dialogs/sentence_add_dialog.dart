import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lugat_admin/main.dart';

import '../../controllers/main_controller.dart';
import '../../models/concrete/sentence_model.dart';
import '../../utilities/custom_class/utilities_class.dart';

/// Created by Yunus Emre Yıldırım
/// on 12.09.2022

class SentenceAddDialog {
  final formKey = GlobalKey<FormState>();

  final SentenceModel? currentSentence;

  late TextEditingController textControllerTitle;

  late TextEditingController textControllerContent;
  late MainController mainController;

  String title = '';
  String content = '';

  SentenceAddDialog({required this.currentSentence}) {
    textControllerTitle = TextEditingController();
    textControllerContent = TextEditingController();
    mainController = Get.find();

    showSentenceAddDialog;
  }

  void get showSentenceAddDialog {
    Get.defaultDialog(
      title: 'Kelime Ekleyin',
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

                        try {
                          String id = fireStore.collection('Sentence').doc().id;
                          String coTitle = UtilitiesClass.getCoTitle(title);
                          SentenceModel sentence = SentenceModel(id: id, title: title, content: content, isRating: 0, coTitle: coTitle);
                          fireStore.doc('Sentence/$id').set(sentence.toJson());
                          mainController.sentenceList.add(sentence);

                          textControllerTitle.clear();
                          textControllerContent.clear();
                          Get.back();
                          Get.snackbar(
                            'BİLGİ',
                            'Cümle başarıyla kaydedildi.',
                            borderColor: Colors.green,
                            borderWidth: 2,
                            snackPosition: SnackPosition.BOTTOM,
                            maxWidth: MediaQuery.of(context).size.width * 0.4,
                          );
                        } catch (e) {
                          debugPrint('Hata oluştu. ${e.toString()}');
                        }
                      }
                    },
                    child: const Text('KAYDET'),
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

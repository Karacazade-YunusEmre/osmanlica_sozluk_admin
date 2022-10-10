import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/main_controller.dart';
import '../../../models/concrete/sentence_model.dart';

/// Created by Yunus Emre Yıldırım
/// on 12.09.2022

class SentenceAddUpdateDialog {
  final SentenceModel? currentSentence;

  late MainController mainController;
  final formKey = GlobalKey<FormState>();
  late TextEditingController textControllerTitle;
  late TextEditingController textControllerContent;
  String title = '';
  String content = '';

  SentenceAddUpdateDialog({required this.currentSentence}) {
    mainController = Get.find();
    textControllerTitle = TextEditingController(text: currentSentence != null ? currentSentence!.title : '');
    textControllerContent = TextEditingController(text: currentSentence != null ? currentSentence!.content : '');

    showSentenceAddDialog;
  }

  void get showSentenceAddDialog {
    Get.defaultDialog(
      title: currentSentence != null ? 'Cümleyi Güncelleyin' : 'Cümle Ekleyin',
      titleStyle: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
      content: SizedBox(
        width: 0.4.sw,
        height: 0.4.sh,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: textControllerContent,
                  maxLines: 5,
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
              ),
              Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        /// add sentence
                        if (currentSentence == null) {
                          try {
                            mainController.addSentence(title: title, content: content);
                          } catch (e) {
                            debugPrint('Hata oluştu. ${e.toString()}');
                          }
                        }

                        /// for add sentence
                        else {
                          mainController.updateSentence(currentModel: currentSentence!, title: title, content: content);
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
                          maxWidth: 0.4.sw,
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

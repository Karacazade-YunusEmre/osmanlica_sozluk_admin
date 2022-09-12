import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utilities/custom_class/utilities_class.dart';
import '../components/widgets/sentence_list_widget.dart';
import '/models/concrete/sentence_model.dart';
import '../../controllers/main_controller.dart';
import '../../main.dart';
import '../components/widgets/search_bar_widget.dart';

/// Created by Yunus Emre Yıldırım
/// on 24.08.2022

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MainController mainController;
  late TextEditingController searchBarController;

  @override
  void initState() {
    super.initState();

    user.authStateChanges().listen((User? user) {
      if (user == null) {
        Get.toNamed('/login');
        debugPrint('User is currently signed out!');
      } else {
        debugPrint('User is signed in!');
      }
    });

    mainController = Get.find();
    searchBarController = TextEditingController();
  }

  @override
  void dispose() {
    mainController.dispose();
    searchBarController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 5,
        title: const Text('Lugat Yönetici Paneli'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBarWidget(
              textController: searchBarController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.shade400.withOpacity(0.7),
                shape: const StadiumBorder(),
              ),
              onPressed: () => user.signOut(),
              child: const Text('Çıkış Yap'),
            ),
          ),
        ],
      ),
      body: SentenceListWidget(updateSentence: getModalBottomSheet),
      floatingActionButton: FloatingActionButton(
        onPressed: () => getModalBottomSheet(null),
        child: const Icon(Icons.add_box),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  void getModalBottomSheet(SentenceModel? selectedSentence) {
    final formKey = GlobalKey<FormState>();
    TextEditingController textControllerTitle = TextEditingController(text: selectedSentence != null ? selectedSentence.title : '');
    TextEditingController textControllerContent = TextEditingController(text: selectedSentence != null ? selectedSentence.content : '');
    String title = '';
    String content = '';

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: textControllerTitle,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Başlık alanını girin',
                        label: Text('Başlık'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Başlık alanı boş bırakılamaz';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        title = value!;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: textControllerContent,
                      decoration: const InputDecoration(
                        hintText: 'İçerik alanını girin',
                        label: Text('İçerik'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'İçerik alanı boş bırakılamaz';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        content = value!;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(fixedSize: const Size(30, 20)),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          String coTitle = UtilitiesClass.getCoTitle(title);

                          if (selectedSentence == null) {
                            String id = fireStore.collection('Sentence').doc().id;

                            SentenceModel sentenceModel = SentenceModel(id: id, title: title, content: content, isRating: 0, coTitle: coTitle);

                            fireStore.doc('Sentence/$id').set(sentenceModel.toJson());
                            mainController.sentenceList.add(sentenceModel);

                            textControllerTitle.clear();
                            textControllerContent.clear();
                            Navigator.pop(context);
                            Get.snackbar('', 'Kayıt işlemi başarılı');
                          } else {
                            selectedSentence.title = title;
                            selectedSentence.content = content;
                            selectedSentence.coTitle = coTitle;

                            fireStore.doc('Sentence/${selectedSentence.id}').update(selectedSentence.toJson());
                            mainController.updateSentence(selectedSentence);
                            Get.back();
                            Get.snackbar('', 'Güncelleme işlemi başarılı');
                          }
                        }
                      },
                      child: Text(selectedSentence == null ? 'Kaydet' : 'Güncelle'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

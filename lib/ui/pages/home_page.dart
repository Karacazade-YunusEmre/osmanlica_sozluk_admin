import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utilities/sentence_list.dart';
import '/models/concrete/sentence_model.dart';
import '../../main.dart';
import '../../models/concrete/sentence_model.dart';
import '../components/widgets/custom_search_page.dart';
import '../components/widgets/sentence_list_widget.dart';

/// Created by Yunus Emre Yıldırım
/// on 24.08.2022

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> snapShotCollection;

  @override
  void initState() {
    super.initState();

    user.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushNamed(context, '/login');
        debugPrint('User is currently signed out!');
      } else {
        debugPrint('User is signed in!');
      }
    });

    snapShotCollection = fireStore.collection('Sentence').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Lugat Yönetici Paneli'),
        centerTitle: true,
        actions: [
          // Padding(
          //   padding: EdgeInsets.all(16.0.sp),
          //   child: IconButton(
          //     onPressed: () async {
          //       for (Map<String, dynamic> item in sentenceList) {
          //         String coTitle = getCoTitle(item['title']);
          //         String id = fireStore.collection('Sentence').doc().id;
          //         SentenceModel sentenceModel = SentenceModel(id: id, title: item['title'], content: item['content'], isRating: 0, coTitle: coTitle);
          //
          //         fireStore.doc('Sentence/$id').set(sentenceModel.toJson());
          //       }
          //     },
          //     icon: Icon(
          //       Icons.add,
          //       size: 130.sp,
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.all(16.0.sp),
            child: IconButton(
              onPressed: showSearchPage,
              icon: Icon(
                Icons.search,
                size: 130.sp,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0.sp),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent.shade400.withOpacity(0.7),
              ),
              onPressed: () => user.signOut(),
              child: const Text('Çıkış Yap'),
            ),
          ),
        ],
      ),
      body: SentenceListWidget(snapshotCollection: snapShotCollection, updateSentence: getModalBottomSheet),
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
            height: 0.4.sh,
            padding: EdgeInsets.all(16.sp),
            margin: EdgeInsets.all(16.sp),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0.sp),
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
                    padding: EdgeInsets.all(16.0.sp),
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
                    padding: EdgeInsets.all(32.0.sp),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(fixedSize: Size(0.3.sw, 0.06.sh)),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          String coTitle = getCoTitle(title);

                          if (selectedSentence == null) {
                            String id = fireStore.collection('Sentence').doc().id;

                            SentenceModel sentenceModel = SentenceModel(id: id, title: title, content: content, isRating: 0, coTitle: coTitle);

                            fireStore.doc('Sentence/$id').set(sentenceModel.toJson());

                            textControllerTitle.clear();
                            textControllerContent.clear();
                            Navigator.pop(context);
                            Get.snackbar('', 'Kayıt işlemi başarılı');
                          } else {
                            selectedSentence.title = title;
                            selectedSentence.content = content;
                            selectedSentence.coTitle = coTitle;

                            fireStore.doc('Sentence/${selectedSentence.id}').update(selectedSentence.toJson());
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

  String getCoTitle(String title) {
    String temp = title;

    List<String> patternList = [' ', '-', "'", '(', ')', '.', ':', ',', ';', '{', '}', '[', ']', '!', '?'];

    for (String item in patternList) {
      temp = temp.split(item).join();
    }

    return temp.toLowerCase();
  }

  void showSearchPage() {
    showSearch(context: context, delegate: CustomSearchPage(updateSentence: getModalBottomSheet));
  }
}

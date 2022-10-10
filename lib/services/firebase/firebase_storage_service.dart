import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lugat_admin/models/concrete/sentence_model.dart';
import 'package:lugat_admin/services/base/i_sentence_base_storage_service.dart';

/// Created by Yunus Emre Yıldırım
/// on 6.10.2022

class FirebaseStorageService implements ISentenceBaseStorageService {
  late FirebaseFirestore fireStore;

  FirebaseStorageService() {
    fireStore = FirebaseFirestore.instance;
  }

  @override
  Future<String?> add(SentenceModel item) async {
    try {
      String firebaseId = getFirebaseDocId;
      item.id = firebaseId;
      await fireStore.doc('Sentence/${item.id}').set(item.toJson());
      return firebaseId;
    } catch (e) {
      debugPrint('firestore ekleme işlemi sırasında hata oluştu. ${e.toString()}');
      return null;
    }
  }

  @override
  Future<bool?> delete(SentenceModel item) async {
    try {
      await fireStore.doc('Sentence/${item.id}').delete();
      return true;
    } catch (e) {
      debugPrint('firebase den silme işlemi sırasında hata oluştu. ${e.toString()}');
      return false;
    }
  }

  @override
  Future<List<SentenceModel>?> getAll() async {
    try {
      List<SentenceModel> sentenceList = [];
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await fireStore.collection('Sentence').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> item in querySnapshot.docs) {
        SentenceModel sentenceModel = SentenceModel.fromJson(item.data());
        sentenceList.add(sentenceModel);
      }
      return sentenceList;
    } catch (e) {
      debugPrint('Firebase den veri çekme işlemi sırasında hata oluştu. ${e.toString()}');
      return null;
    }
  }

  @override
  Future<String?> update(SentenceModel item) async {
    try {
      await fireStore.doc('Sentence/${item.id}').update(item.toJson());
      return item.id;
    } catch (e) {
      debugPrint('firebase de güncelleme işlemi sırasında hata oluştu. ${e.toString()}');
      return null;
    }
  }

  String get getFirebaseDocId {
    String id = fireStore.collection('Sentence').doc().id;
    return id;
  }
}

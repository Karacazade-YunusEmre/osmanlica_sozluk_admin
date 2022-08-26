import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../main.dart';
import '../../../models/concrete/sentence_model.dart';
import 'sentence_list_widget.dart';

/// Created by Yunus Emre Yıldırım
/// on 25.08.2022

class CustomSearchPage extends SearchDelegate {
  final void Function(SentenceModel) updateSentence;

  CustomSearchPage({required this.updateSentence});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          size: 130.sp,
        ),
        onPressed: () => query.isEmpty ? null : query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        size: 130.sp,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: snapShotCollection,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text('Veriler getiriliyor ...'),
          );
        } else {
          List<SentenceModel> sentenceList = [];
          for (QueryDocumentSnapshot<Map<String, dynamic>> element in snapshot.data!.docs) {
            SentenceModel sentenceModel = SentenceModel.fromJson(element.data());
            sentenceList.add(sentenceModel);
          }
          List<SentenceModel> filteredList = sentenceList.where((model) {
            return model.coTitle.toLowerCase().contains(query.toLowerCase());
          }).toList();
          return SentenceListWidget(sentenceList: filteredList, updateSentence: updateSentence);
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

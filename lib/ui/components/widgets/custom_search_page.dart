import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lugat_admin/ui/components/widgets/sentence_list_widget.dart';

import '../../../main.dart';
import '../../../models/concrete/sentence_model.dart';

/// Created by Yunus Emre Yıldırım
/// on 25.08.2022

class CustomSearchPage extends SearchDelegate {
  final void Function(SentenceModel) updateSentence;
  late Stream<QuerySnapshot<Map<String, dynamic>>> snapShotCollection;

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
    snapShotCollection = fireStore.collection('Sentence').where('coTitle', isGreaterThanOrEqualTo: query.toLowerCase()).where('coTitle', isLessThanOrEqualTo: query.toLowerCase()).snapshots();
    return SentenceListWidget(snapshotCollection: snapShotCollection, updateSentence: updateSentence);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

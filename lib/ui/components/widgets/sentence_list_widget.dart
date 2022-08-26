import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lugat_admin/ui/components/widgets/custom_expansion_tile.dart';

import '../../../models/concrete/sentence_model.dart';

/// Created by Yunus Emre Yıldırım
/// on 25.08.2022

class SentenceListWidget extends StatefulWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> snapshotCollection;
  final void Function(SentenceModel) updateSentence;

  const SentenceListWidget({Key? key, required this.snapshotCollection, required this.updateSentence}) : super(key: key);

  @override
  State<SentenceListWidget> createState() => _SentenceListWidgetState();
}

class _SentenceListWidgetState extends State<SentenceListWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.snapshotCollection,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text('Veriler getiriliyor ...'),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              SentenceModel currentSentence = SentenceModel.fromJson(snapshot.data!.docs[index].data());
              return CustomExpansionTile(
                currentSentence: currentSentence,
                updateFunction: widget.updateSentence,
                title: Container(
                  margin: EdgeInsets.all(8.0.sp),
                  padding: EdgeInsets.all(32.0.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.sp)),
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                  ),
                  child: Center(
                    child: Text(
                      currentSentence.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 70.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                children: [
                  Container(
                    margin: EdgeInsets.all(8.0.sp),
                    padding: EdgeInsets.all(32.0.sp),
                    width: 0.9.sw,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.sp)),
                      color: Theme.of(context).primaryColor.withOpacity(0.7),
                    ),
                    child: Text(
                      currentSentence.content,
                      style: TextStyle(
                        fontSize: 60.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}

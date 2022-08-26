import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lugat_admin/ui/components/widgets/custom_expansion_tile.dart';

import '../../../models/concrete/sentence_model.dart';

/// Created by Yunus Emre Yıldırım
/// on 25.08.2022

class SentenceListWidget extends StatefulWidget {
  final List<SentenceModel> sentenceList;
  final void Function(SentenceModel) updateSentence;

  const SentenceListWidget({Key? key, required this.sentenceList, required this.updateSentence}) : super(key: key);

  @override
  State<SentenceListWidget> createState() => _SentenceListWidgetState();
}

class _SentenceListWidgetState extends State<SentenceListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.sentenceList.length,
      itemBuilder: (BuildContext context, int index) {
        SentenceModel currentSentence = widget.sentenceList[index];
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
}

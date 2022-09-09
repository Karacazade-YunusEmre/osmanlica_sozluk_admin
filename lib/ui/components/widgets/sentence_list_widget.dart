import 'package:flutter/material.dart';
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
  late Size _screenSize;

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    return ListView.builder(
      itemCount: widget.sentenceList.length,
      itemBuilder: (BuildContext context, int index) {
        SentenceModel currentSentence = widget.sentenceList[index];
        return CustomExpansionTile(
          currentSentence: currentSentence,
          updateFunction: widget.updateSentence,
          title: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Theme.of(context).primaryColor.withOpacity(0.7),
            ),
            child: Center(
              child: Text(
                currentSentence.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              width: _screenSize.width * 0.9,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Theme.of(context).primaryColor.withOpacity(0.7),
              ),
              child: Text(
                currentSentence.content,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}

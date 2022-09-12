import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '/ui/components/widgets/sentence_item_widget.dart';
import '../../../controllers/main_controller.dart';
import '../../../models/concrete/sentence_model.dart';

/// Created by Yunus Emre Yıldırım
/// on 25.08.2022

class SentenceListWidget extends StatefulWidget {
  const SentenceListWidget({Key? key}) : super(key: key);

  @override
  State<SentenceListWidget> createState() => _SentenceListWidgetState();
}

class _SentenceListWidgetState extends State<SentenceListWidget> {
  late MainController mainController;

  @override
  void initState() {
    mainController = Get.find();

    super.initState();
  }

  @override
  void dispose() {
    mainController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Obx(
      () => Container(
        width: screenSize.width,
        height: screenSize.height,
        color: const Color(0xFF4FC3F7),
        child: Center(
          child: Container(
            width: screenSize.width * 0.5,
            height: screenSize.height,
            padding: const EdgeInsets.all(8.0),
            child: AnimationLimiter(
              child: ListView.builder(
                itemCount: mainController.sentenceList.length,
                itemBuilder: (BuildContext context, int index) {
                  SentenceModel currentSentence = mainController.sentenceList[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(seconds: 2),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SentenceItemWidget(currentSentence: currentSentence),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

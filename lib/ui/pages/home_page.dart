import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lugat_admin/main.dart';

import '../components/dialogs/sentence_add_update_dialog.dart';
import '../components/widgets/home_page_app_bar.dart';
import '../components/widgets/sentence_list_widget.dart';

/// Created by Yunus Emre Yıldırım
/// on 24.08.2022

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // user.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     Get.toNamed('/login');
    //     debugPrint('User is currently signed out!');
    //   } else {
    //     debugPrint('User is signed in!');
    //   }
    // });

    checkUserCurrentState();
  }

  Future<void> checkUserCurrentState() async {
    bool state = await serviceAuth.isUserSignIn();
    if (state) {
      debugPrint('User is signed in!');
    } else {
      Get.toNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          HomePageAppBar(),
          SentenceListWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => SentenceAddUpdateDialog(currentSentence: null),
        child: const Icon(Icons.add_box),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

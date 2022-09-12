import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/main_controller.dart';
import '../../main.dart';
import '../components/widgets/search_bar_widget.dart';
import '../components/widgets/sentence_list_widget.dart';
import '../dialogs/sentence_add_dialog.dart';

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
      body: const SentenceListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => SentenceAddDialog(currentSentence: null),
        child: const Icon(Icons.add_box),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

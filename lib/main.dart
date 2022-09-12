import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_strategy/url_strategy.dart';

import '/controllers/main_controller.dart';
import 'firebase_options.dart';
import 'utilities/constants/routes.dart';
import 'utilities/constants/ui_constant.dart';

late FirebaseAuth user;
late FirebaseFirestore fireStore;
late QuerySnapshot<Map<String, dynamic>> sentenceCollection;

void main() async {
  init;
  await initFirebase;
  setupController;
  runApp(const MainApp());
}

void get init {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
}

Future<void> get initFirebase async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  user = FirebaseAuth.instance;
  fireStore = FirebaseFirestore.instance;
  sentenceCollection = await fireStore.collection('Sentence').get();
}

void get setupController {
  Get.put(MainController());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lugat Admin',
      theme: defaultThemeData,
      getPages: routes,
      builder: (BuildContext context, Widget? child) {
        return ResponsiveWrapper.builder(
          child,
          maxWidth: 1200,
          minWidth: 480,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ],
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'utilities/constants/route_generator.dart';

late FirebaseAuth user;
late FirebaseFirestore fireStore;
late Stream<QuerySnapshot<Map<String, dynamic>>> snapShotCollection;

void main() async {
  await init;
  await initFirebase;
  runApp(EasyLocalization(
    supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
    path: 'assets/translation',
    fallbackLocale: const Locale('tr', 'TR'),
    child: const MainApp(),
  ));
}

Future<void> get init async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
}

Future<void> get initFirebase async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  user = FirebaseAuth.instance;
  fireStore = FirebaseFirestore.instance;
  snapShotCollection = fireStore.collection('Sentence').snapshots();
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      splitScreenMode: true,
      minTextAdapt: true,
      designSize: const Size(1440, 2960),
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.deviceLocale,
          title: 'Lugat Admin',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          onGenerateRoute: RouteGenerator.getRoutes,
        );
      },
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:url_strategy/url_strategy.dart';

import '/controllers/main_controller.dart';
import '/services/base/i_base_auth_service.dart';
import '/services/base/i_sentence_base_storage_service.dart';
import '/services/firebase/firebase_auth_service.dart';
import '/ui/pages/page_not_found.dart';
import 'firebase_options.dart';
import 'services/firebase/firebase_storage_service.dart';
import 'utilities/routes.dart';
import 'utilities/ui_constant.dart';

late ISentenceBaseStorageService serviceStorage;
late IBaseAuthService serviceAuth;

void main() async {
  init;
  await setupService();
  setupLocator();
  setupController;
  runApp(const MainApp());
}

void get init {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
}

Future<void> setupService() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void setupLocator() {
  final getIt = GetIt.instance;

  getIt.registerSingleton<ISentenceBaseStorageService>(FirebaseStorageService());
  getIt.registerSingleton<IBaseAuthService>(FirebaseAuthService());

  serviceStorage = getIt<ISentenceBaseStorageService>();
  serviceAuth = getIt<IBaseAuthService>();
}

void get setupController {
  Get.put(MainController());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1366, 768),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Lugat Admin',
          theme: UIConstant.getDefaultThemeData,
          getPages: GenerateRoute.getRoutes,
          unknownRoute: GetPage(
            name: '/page_not_found',
            page: () => const PageNotFound(),
            transition: Transition.leftToRightWithFade,
            transitionDuration: const Duration(milliseconds: 375),
          ),
        );
      },
    );
  }
}

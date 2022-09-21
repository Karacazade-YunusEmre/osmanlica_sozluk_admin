import 'package:get/get.dart';

import '../../ui/pages/home_page.dart';
import '../../ui/pages/log_in_page.dart';

/// Created by Yunus Emre Yıldırım
/// on 12.09.2022

class GenerateRoute {
  static const Duration defaultTransitionDuration = Duration(milliseconds: 375);

  static List<GetPage> get getRoutes {
    return [
      GetPage(
        name: '/',
        page: () => const HomePage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: defaultTransitionDuration,
      ),
      GetPage(
        name: '/login',
        page: () => const LoginPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: defaultTransitionDuration,
      ),
    ];
  }
}

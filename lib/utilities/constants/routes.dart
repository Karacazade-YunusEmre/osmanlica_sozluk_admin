import 'package:get/get.dart';

import '../../ui/pages/home_page.dart';
import '../../ui/pages/log_in_page.dart';

/// Created by Yunus Emre Yıldırım
/// on 12.09.2022

const Duration defaultTransitionDuration = Duration(milliseconds: 375);

final List<GetPage> routes = [
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

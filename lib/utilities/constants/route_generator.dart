import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lugat_admin/ui/pages/log_in_page.dart';

import '../../ui/pages/home_page.dart';
import '../../ui/pages/page_not_found.dart';



/// Created by Yunus Emre Yıldırım
/// on 24.08.2022

class RouteGenerator {
  static Route<dynamic>? getRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _getPageRoute(const HomePage(), settings);

      case '/login':
        return _getPageRoute(const LogInPage(), settings);

      default:
        return _getPageRoute(const PageNotFound(), settings);
    }
  }

  static Route<dynamic>? _getPageRoute(Widget route, RouteSettings settings) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageRoute(builder: (BuildContext context) => route, settings: settings);
    } else {
      return MaterialPageRoute(builder: (BuildContext context) => route, settings: settings);
    }
  }
}

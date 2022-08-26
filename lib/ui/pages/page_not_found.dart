import 'package:flutter/material.dart';

/// Created by Yunus Emre Yıldırım
/// on 24.08.2022

class PageNotFound extends StatelessWidget {
  const PageNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('/images/page_not_found.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

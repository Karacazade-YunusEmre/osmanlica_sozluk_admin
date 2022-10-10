import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../main.dart';
import 'search_bar_widget.dart';

/// Created by Yunus Emre Yıldırım
/// on 10.10.2022

class HomePageAppBar extends StatefulWidget {
  const HomePageAppBar({Key? key}) : super(key: key);

  @override
  State<HomePageAppBar> createState() => _HomePageAppBarState();
}

class _HomePageAppBarState extends State<HomePageAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 0.1.sh,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ///#region title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Osmanlıca Sözlük Yönetici Paneli',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          ///#endregion title row

          ///#region searchBar and signout button row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: SearchBarWidget(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.shade400.withOpacity(0.7),
                    textStyle: TextStyle(color: Theme.of(context).primaryColor,),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    try {
                      serviceAuth.signOut();
                      Get.offAndToNamed('/');
                    } catch (e) {
                      debugPrint('Oturum kapatma işlemi sırasında hata oluştu. ${e.toString()}');
                    }
                  },
                  child: const Text('Çıkış Yap'),
                ),
              ),
            ],
          ),

          ///#endregion searchBar and signout button row
        ],
      ),
    );
  }
}

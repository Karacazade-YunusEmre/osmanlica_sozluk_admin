import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:lugat_admin/controllers/main_controller.dart';

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
  late MainController mainController;

  @override
  void initState() {
    super.initState();

    mainController = Get.find();
  }

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
          ///#region title and nightMode row
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(
                  () => FlutterSwitch(
                    width: 0.1.sw,
                    height: 0.06.sh,
                    valueFontSize: 25.sp,
                    toggleSize: 45.0,
                    value: mainController.nightModeStatus,
                    borderRadius: 30.0,
                    // padding: 8,
                    showOnOff: true,
                    activeToggleColor: const Color(0xFF6E40C9),
                    inactiveToggleColor: const Color(0xFF2F363D),
                    activeSwitchBorder: Border.all(
                      color: const Color(0xFF3C1E70),
                      width: 2.0,
                    ),
                    inactiveSwitchBorder: Border.all(
                      color: const Color(0xFFD1D5DA),
                      width: 2.0,
                    ),
                    activeColor: const Color(0xFF271052),
                    inactiveColor: Colors.white,
                    activeIcon: const Icon(
                      Icons.nightlight_round,
                      color: Color(0xFFF8E3A1),
                    ),
                    inactiveIcon: const Icon(
                      Icons.wb_sunny,
                      color: Color(0xFFFFDF5D),
                    ),
                    activeText: 'Açık',
                    inactiveText: 'Kapalı',
                    activeTextColor: Colors.white,
                    inactiveTextColor: Colors.black,

                    onToggle: (bool value) => mainController.nightModeSwitchToggle(context, value),
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
                    textStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
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

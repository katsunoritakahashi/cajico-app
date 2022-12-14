import 'package:cajico_app/ui/common/app_color.dart';
import 'package:cajico_app/ui/controller/base_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BaseViewController());
    return SizedBox(
      height: 60,
      child: Obx(
        () => BottomNavigationBar(
          onTap: controller.onTapBottomNavigation,
          currentIndex: controller.tabIndex.value,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(LineIcons.home),
              activeIcon: Icon(LineIcons.home),
              label: '家事',
            ),
            BottomNavigationBarItem(
              icon: Icon(LineIcons.gift),
              label: 'ごほうび',
            ),
            BottomNavigationBarItem(
              icon: Icon(LineIcons.history),
              label: '履歴',
            ),
          ],
          backgroundColor: Colors.white,
          iconSize: 25,
          unselectedFontSize: 12,
          selectedIconTheme: const IconThemeData(size: 31),
          selectedFontSize: 12,
          selectedItemColor: primaryColor,
        ),
      ),
    );
  }
}

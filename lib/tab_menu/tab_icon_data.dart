import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
    this.sub,
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;
  List<Map<String, dynamic>> sub;

  AnimationController animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/tab_icons/tab_1s.png',
      selectedImagePath: 'assets/tab_icons/tab_1.png',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/tab_icons/tab_2s.png',
      selectedImagePath: 'assets/tab_icons/tab_2.png',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/tab_icons/tab_3s.png',
      selectedImagePath: 'assets/tab_icons/tab_3.png',
      index: 2,
      isSelected: false,
      sub: [
        {
          "name": "Dashboard Proyek",
          "route": "/owner_proyek",
          'index': 0,
        },
        {
          "name": "Dashboard Layanan",
          "route": "/owner_layanan",
          'index': 1,
        }
      ],
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/tab_icons/tab_4s.png',
      selectedImagePath: 'assets/tab_icons/tab_4.png',
      index: 3,
      isSelected: false,
      animationController: null,
      sub: [
        {
          "name": "Dashboard Proyek",
          "route": "/owner_proyek",
          'index': 0,
        },
        {
          "name": "Dashboard Layanan",
          "route": "/owner_layanan",
          'index': 1,
        }
      ],
    ),
    TabIconData(
      imagePath: 'assets/tab_icons/tab_5s.png',
      selectedImagePath: 'assets/tab_icons/tab_5.png',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}

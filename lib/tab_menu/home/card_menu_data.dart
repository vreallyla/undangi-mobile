import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';

class CardMenuData {
  CardMenuData({
    this.imagePath = '',
    this.index = 0,
    this.bingkaiColor = AppTheme.contentBrown,
    this.bgColor = AppTheme.bgRedSoft,
    this.title = '',
    this.subtitle = '',
    this.animationController,
    this.count:-1
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  Color bingkaiColor;
  Color bgColor;
  String title;
  String subtitle;
  int index;
  int count;

  AnimationController animationController;

  static List<CardMenuData> cardMenuDataList = <CardMenuData>[
    CardMenuData(
      imagePath: 'assets/home/engineering.png',
      index: 0,
      bingkaiColor: AppTheme.contentBrown,
      bgColor: AppTheme.bgRedSoft,
      title: 'Membuat Proyek Sendiri',
      subtitle: 'Tanpa Batasan Kategori',
      animationController: null,
      
    ),
    CardMenuData(
      imagePath: 'assets/home/briefcase.png',
      index: 1,
      bingkaiColor: AppTheme.contentYellow,
      bgColor: AppTheme.bgYellowSoft,
      title: 'Menawarkan Jasa Layanan-mu',
      subtitle: 'Tawarkan Layanan-mu',
      animationController: null,
    ),
    CardMenuData(
      imagePath: 'assets/home/people.png',
      index: 2,
      bingkaiColor: AppTheme.contentBlue,
      bgColor: AppTheme.bgBlueSoft,
      title: 'Mencari Pekerjaan Untuk Proyekmu',
      subtitle: 'Pekerja yang Kompeten',
      animationController: null,
    ),
  ];
}

import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';

// import 'package:undangi/Constant/app_theme.dart';

class SearchTabScreen extends StatefulWidget {
  @override
  _SearchTabScreenState createState() => _SearchTabScreenState();
}

class _SearchTabScreenState extends State<SearchTabScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  // List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  // void initState() {
  //   tabIconsList.forEach((TabIconData tab) {
  //     tab.isSelected = false;
  //   });
  //       tabIconsList[0].isSelected = true;

  // }

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('search tab'));
  }
}

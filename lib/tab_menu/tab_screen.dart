import 'package:flutter/material.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/tab_menu/home/home_screen.dart';
import 'package:undangi/tab_menu/profile/profile_screen.dart';

import 'search/search_tab_screen.dart';
import 'tab_icon_data.dart';
import 'tab_bar_navigation_view.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with TickerProviderStateMixin {
  AnimationController animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  int routeIndex = 0;

  Widget tabBody = Container(
    color: AppTheme.chipBackground,
  );

  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;
    tabBody = HomeScreen();
    super.initState();
  }

  void tabChange(int index) {
    if (index == 0) {
      if (!mounted) {
        return;
      }
      setState(() {
        tabBody = HomeScreen();
      });
    } else if (index == 1) {
      if (!mounted) {
        return;
      }
      setState(() {
        tabBody = SearchTabScreen();
      });
    } else if (index == 4) {
      if (!mounted) {
        return;
      }
      setState(() {
        tabBody = ProfileScreen();
      });
    }
  }

  void routeOther(context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null ? arguments['index_route'] != null : false) {
      tabIconsList.forEach((TabIconData tab) {
        tab.isSelected = false;
      });
      tabIconsList[arguments['index_route']].isSelected = true;
      tabChange(arguments['index_route']);
      routeIndex = arguments['index_route'];
    }
  }

  @override
  Widget build(BuildContext context) {
    routeOther(context);
    return Scaffold(
      appBar: appBarColloring(),
      body: SlidingUpPanel(
        minHeight: 30,
        maxHeight: 90,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(60),
          topLeft: Radius.circular(60),
        ),
        color: AppTheme.primaryBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.0),
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
        //slideup
        panel: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 10, bottom: 15),
              child: Container(
                height: 8,
                width: 100,
                color: Colors.white,
              ),
            ),
            TabBarNavigationView(
                tabIconsList: tabIconsList,
                addClick: () {},
                changeIndex: (int index) {
                  if (routeIndex != index) {
                    if ([0, 4].contains(index)) {
                      Navigator.pushNamed(context, '/home',
                          arguments: {"index_route": index});
                    } else {
                      if (index == 1) {
                        Navigator.pushNamed(
                          context,
                          '/search_kategori',
                        );
                      }
                    }
                  }
                })
          ],
        ),

        // conten
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  // bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }
}

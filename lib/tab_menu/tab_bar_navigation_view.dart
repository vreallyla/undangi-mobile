import 'package:flutter/material.dart';

import 'tab_icon_data.dart';

class TabBarNavigationView extends StatefulWidget {
  const TabBarNavigationView(
      {Key key, this.tabIconsList, this.changeIndex, this.addClick})
      : super(key: key);

  final Function(int index) changeIndex;
  final Function addClick;
  final List<TabIconData> tabIconsList;

  @override
  _TabBarNavigationViewState createState() => _TabBarNavigationViewState();
}

class _TabBarNavigationViewState extends State<TabBarNavigationView>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      height: 40,
      width: double.infinity,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 0, bottom: 0, right: 25, left: 25),
        itemCount: widget.tabIconsList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          // final int count = 5;
          // final Animation<double> animation =
          //     Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          //         parent: animationController,
          //         curve: Interval((1 / count) * index, 1.0,
          //             curve: Curves.fastOutSlowIn)));
          // animationController.forward();
          // print(widget.tabIconsList[index].sub);
          // print(index);

          return widget.tabIconsList[index].sub != null
              ? withSub(index, sizeu)
              : withoutSub(index, sizeu);
        },
      ),
    );
  }

  Widget withoutSub(int index, sizeu) {
    return Container(
        alignment: Alignment.center,
        width: (sizeu.width - 50) / 5,
        child: InkWell(
          onTap: () {
            // setRemoveAllSelection(widget.tabIconsList[index]);
            widget.changeIndex(index);
          },
          child: SizedBox(
              width: 80,
              height: 80,
              child: (Image.asset(widget.tabIconsList[index].isSelected
                  ? widget.tabIconsList[index].selectedImagePath
                  : widget.tabIconsList[index].imagePath))),
        ));
  }

  Widget withSub(int index, sizeu) {
    return PopupMenuButton(
      child: Container(
        alignment: Alignment.center,
        width: (sizeu.width - 50) / 5,
        child: SizedBox(
            width: 80,
            height: 80,
            child: (Image.asset(widget.tabIconsList[index].isSelected
                ? widget.tabIconsList[index].selectedImagePath
                : widget.tabIconsList[index].imagePath))),
      ),
      onSelected: (newValue) {
        Navigator.pushNamed(
          context,
          widget.tabIconsList[index].sub[newValue]['route'],
        );
      },
      itemBuilder: (context) => widget.tabIconsList[index].sub.map((e) {
        return PopupMenuItem(
          child: Text(e['name']),
          value: e['index'],
        );
      }).toList(),
    );
  }

  void setRemoveAllSelection(TabIconData tabIconData) {
    if (!mounted) return;
    setState(() {
      widget.tabIconsList.forEach((TabIconData tab) {
        tab.isSelected = false;
        if (tabIconData.index == tab.index) {
          tab.isSelected = true;
        }
      });
    });
  }
}

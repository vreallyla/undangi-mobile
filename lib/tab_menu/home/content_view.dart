import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';

import 'card_menu_data.dart';

class HomeContentView extends StatefulWidget {
  const HomeContentView(
      {Key key, this.cardMenuData, this.changeIndex, this.addClick})
      : super(key: key);

  final Function(int index) changeIndex;
  final Function addClick;
  final List<CardMenuData> cardMenuData;

  @override
  _HomeContentViewState createState() => _HomeContentViewState();
}

class _HomeContentViewState extends State<HomeContentView>
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
      width: double.infinity,
      height: 360,
      child: ListView.builder(
        // padding: const EdgeInsets.only(top: 0, bottom: 0, right: 25, left: 25),
        itemCount: widget.cardMenuData.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          // final int count = 5;
          // final Animation<double> animation =
          //     Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          //         parent: animationController,
          //         curve: Interval((1 / count) * index, 1.0,
          //             curve: Curves.fastOutSlowIn)));
          // animationController.forward();

          return InkWell(
            onTap: () {
              widget.changeIndex(index);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: widget.cardMenuData[index].bgColor,
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // icon 70
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppTheme.bgIcoGrey,
                      border: Border.all(
                        color: widget.cardMenuData[index].bingkaiColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      widget.cardMenuData[index].imagePath,
                      scale: .6,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  // text 160
                  Container(
                    width: 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.cardMenuData[index].title,
                          style: TextStyle(
                            color: AppTheme.textBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.cardMenuData[index].subtitle,
                          style: TextStyle(
                            color: AppTheme.textPink,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  // count jumlah 20
                  Container(
                    width: 40,
                    padding: EdgeInsets.only(right: 10),
                    alignment: Alignment.center,
                    child: Text(
                      '99+',
                      style: TextStyle(
                        color: AppTheme.textBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    width: sizeu.width - 80 - 20 - 70 - 30 - 10 - 160,
                    alignment: Alignment.centerRight,
                    child: Stack(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/home/circle_quatral.png'),
                              fit: BoxFit.fitHeight,
                            ),
                            // borderRadius:
                            //     BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: AppTheme.textPink,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';

class UserCardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      width: (sizeu.width - 30) / 2,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.geyCustom, width: 1),
        borderRadius: BorderRadius.circular(10),
        color: AppTheme.primaryWhite,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //photom
          Container(
            alignment: Alignment.center,
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: (AssetImage('assets/general/changwook.jpg')),
                fit: BoxFit.fitWidth,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          //nama
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            alignment: Alignment.topCenter,
            width: (sizeu.width - 30) / 2 - 20 - 40,
            child: Text(
              'Jang Ching Wok',
              style: TextStyle(
                color: AppTheme.geySolidCustom,
                fontSize: 16,
              ),
            ),
          ),
          //location
          Container(
            width: (sizeu.width - 30) / 2 - 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 3),
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: (AssetImage('assets/home/location.png')),
                            fit: BoxFit.fitWidth,
                          ),
                        )),
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      width: (sizeu.width - 30) / 2 - 20 - 17,
                      child: Text(
                        'Alamatnya mana Alam at nya mana Alamatnya mana Alamatnya manas',
                        style: TextStyle(fontSize: 12),
                        maxLines: 3,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          // jml proyek
          Container(
            padding: EdgeInsets.only(top: 5),
            width: (sizeu.width - 30) / 2 - 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                (AssetImage('assets/home/briefcase_black.png')),
                            fit: BoxFit.fitWidth,
                          ),
                        )),
                    Container(
                      // margin: EdgeInsets.only(top: 4),
                      padding: EdgeInsets.only(left: 5),
                      width: (sizeu.width - 30) / 2 - 20 - 17,
                      child: Text(
                        '2 PROYEK',
                        style: TextStyle(fontSize: 12),
                        maxLines: 3,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          //rating
          Container(
            padding: EdgeInsets.only(top: 5),
            width: (sizeu.width - 30) / 2 - 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: (AssetImage('assets/home/thumb.png')),
                            fit: BoxFit.fitWidth,
                          ),
                        )),
                    Container(
                        padding: EdgeInsets.only(left: 5),
                        width: (sizeu.width - 30) / 2 - 20 - 17,
                        child: Row(children: [
                          SizedBox(
                              width: 14,
                              child: Icon(Icons.star,
                                  size: 16, color: Colors.yellow)),
                          SizedBox(
                              width: 14,
                              child: Icon(Icons.star,
                                  size: 16, color: Colors.yellow)),
                          SizedBox(
                              width: 14,
                              child: Icon(Icons.star,
                                  size: 16, color: Colors.yellow)),
                          SizedBox(
                              width: 14,
                              child: Icon(Icons.star,
                                  size: 16, color: Colors.yellow)),
                          SizedBox(
                              width: 14,
                              child: Icon(Icons.star,
                                  size: 16, color: Colors.yellow)),
                          SizedBox(
                            width: (sizeu.width - 30) / 2 - 20 - 17 - 75,
                            child: Text(
                              ' 5/5 (2 Ulasan)',
                              style: TextStyle(fontSize: 10),
                            ),
                          )
                        ]))
                  ],
                )
              ],
            ),
          )
          //time
          ,
          Container(
            padding: EdgeInsets.only(top: 5),
            width: (sizeu.width - 30) / 2 - 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                (AssetImage('assets/home/calender_time.png')),
                            fit: BoxFit.fitWidth,
                          ),
                        )),
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      margin: EdgeInsets.only(top: 3),
                      width: (sizeu.width - 30) / 2 - 20 - 17,
                      child: Text(
                        'Bergabung Sejak : 20 Sept 2020',
                        style: TextStyle(fontSize: 9),
                        maxLines: 3,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            width: (sizeu.width - 30) / 2 - 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: (AssetImage('assets/home/time.png')),
                            fit: BoxFit.fitWidth,
                          ),
                        )),
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      margin: EdgeInsets.only(top: 3),
                      width: (sizeu.width - 30) / 2 - 20 - 17,
                      child: Text(
                        'Update Terakhir : 04 Oct 2020',
                        style: TextStyle(fontSize: 9),
                        maxLines: 3,
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/starReview.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class UserCardView extends StatelessWidget {
  const UserCardView({
    Key key,
    this.data,
 
  }) : super(key: key);

  final Map data;

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
            child: imageLoad(data['foto'], true, 60, 60),
          ),
          //nama
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            alignment: Alignment.topCenter,
            width: (sizeu.width - 30) / 2 - 20 - 40,
            child: Text(
              data['name'],
              style: TextStyle(
                color: AppTheme.geySolidCustom,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
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
                        data['alamat']??'Region belum terdaftar',
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
                        '${data['proyek']!=null?data['proyek'].toString():'0'} PROYEK',
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
                        child: starJadi(double.parse(data['bintang']), data['ulasan'].toString(), 14,14))
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
                        'Bergabung Sejak : '+new DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(data['created_at'])),
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
                        'Update Terakhir : '+new DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(data['updated_at'])),
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

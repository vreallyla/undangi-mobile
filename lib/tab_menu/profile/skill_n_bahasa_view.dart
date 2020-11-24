import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_theme.dart';

class SkillNBahasaView extends StatefulWidget {
  @override
  _SkillNBahasaViewState createState() => _SkillNBahasaViewState();

  const SkillNBahasaView({
    Key key,
    this.dataSkill,
  }) : super(key: key);

  final List dataSkill;
}

class _SkillNBahasaViewState extends State<SkillNBahasaView> {
  int jmlhSkill = 0;
  int trans = 0;
  int max = 0;
  List<Widget> dataWidget = <Widget>[];

  Widget dataKosong() {
    return Container(
      height: 80,
      alignment: Alignment.center,
      child: Text(
        'Anda belum menambah Skill dan Bahasa',
        style: TextStyle(
          color: AppTheme.primaryWhite,
          fontSize: 13,
          // fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget dataAda(context) {
    dataWidget = <Widget>[];
    final sizeu = MediaQuery.of(context).size;

    for (var i = trans * 3;
        i < (trans * 3 + 3 > jmlhSkill ? jmlhSkill : trans * 3 + 3);
        i++) {
      dataWidget.add(Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppTheme.nearlyWhite,
        ),
        margin: EdgeInsets.only(left: 4, right: 4),
        width: (sizeu.width - 90 - (8 * 4)) / 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 50,
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(
                  left: 12,
                  top: 10,
                  bottom: 6,
                  right: 12,
                ),
                child: Text(
                  widget.dataSkill[i]['nama'],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  maxLines: 2,
                )),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 12, bottom: 10),
              child: Text(
                widget.dataSkill[i]['tingkatan'],
                maxLines: 1,
                style: TextStyle(fontSize: 12, color: AppTheme.primaryRed),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ));
    }
    setState(() {});

    return Container(
      width: sizeu.width - 90,
      padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Row(
        children: dataWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    jmlhSkill = widget.dataSkill.length;
    max = (jmlhSkill / 3).ceil() - 1;

    return jmlhSkill == 0
        ? dataKosong()
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 15,
                child: InkWell(
                  onTap: () {
                    if (trans != 0) {
                      setState(() {
                        trans = trans - 1;
                      });
                    }
                  },
                  child: FaIcon(
                    FontAwesomeIcons.angleLeft,
                    color:
                        AppTheme.nearlyWhite.withOpacity(trans == 0 ? 0.6 : 1),
                  ),
                ),
              ),
              dataAda(context),
              SizedBox(
                width: 15,
                child: InkWell(
                  onTap: () {
                    if (max != trans) {
                      setState(() {
                        trans = trans + 1;
                      });
                    }
                  },
                  child: FaIcon(
                    FontAwesomeIcons.angleRight,
                    color: AppTheme.nearlyWhite
                        .withOpacity(trans == max ? 0.6 : 1),
                  ),
                ),
              )
            ],
          );
  }
}

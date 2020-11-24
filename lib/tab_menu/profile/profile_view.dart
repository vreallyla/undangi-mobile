import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/tab_menu/profile/skill_n_bahasa_view.dart';
import 'package:undangi/tab_menu/profile/sub/profil_summary_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({
    Key key,
    this.dataProfile,
    this.checkData,
    this.getApi,
  }) : super(key: key);

  final Map<String, dynamic> dataProfile;
  final bool checkData;
  final Function getApi;
  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      child: Column(
        children: [
          //content profile
          Container(
            margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            decoration: BoxDecoration(
              border: Border.all(width: .5, color: Colors.black),
              borderRadius: BorderRadius.circular(10),
              // color: AppTheme.primaryWhite,
            ),
            child: Column(
              children: [
                contentProfile('Nama', checkVar('name', null)),
                contentProfile('Tanggal Lahir', checkVar('bio', 'tgl_lahir')),
                contentProfile(
                    'Jenis Kelamin', checkVar('bio', 'jenis_kelamin')),
                contentProfile(
                    'Kewarganegaraan', checkVar('bio', 'kewarganegaraan')),
                contentProfile('Telp', checkVar('bio', 'hp')),
                contentProfile('Email', checkVar('email', null)),
                contentProfile('Username', checkVar('username', null)),
                contentProfile('Alamat', checkVar('bio', 'alamat')),
                contentProfile('Kota', checkVar('bio', 'kota')),
                contentProfile(
                    'Nomor Rekening',
                    setRekening() +
                        (checkData ? " (${checkVar('bio', 'bank')})" : '')),
              ],
            ),
          ),
          //sumarry
          Container(
              margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              decoration: BoxDecoration(
                // border: Border.all(width: .5, color: Colors.black),
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.bgBlueSoft,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: (AssetImage('assets/more_icon/file.png')),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      SizedBox(
                        width: sizeu.width - 70 - 20 - 20,
                        child: Text(
                          'Summary',
                          style: TextStyle(
                            color: AppTheme.textBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilSummaryScreen(
                                    summary: checkData
                                        ? dataProfile['bio']['summary']
                                        : ''),
                              )).then((value) {
                            if (value) {
                              getApi();
                            }
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  (AssetImage('assets/more_icon/pen_edit.png')),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // content summary
                  Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Text(
                      checkData
                          ? dataProfile['bio']['summary']
                          : 'Anda belum menambah summary',
                      style: TextStyle(
                        color: AppTheme.textBlue,
                        fontSize: 13,
                        // fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              )),

          //skill bahasa
          Container(
              margin: EdgeInsets.fromLTRB(20, 15, 20, 40),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              decoration: BoxDecoration(
                // border: Border.all(width: .5, color: Colors.black),
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.primaryBluePekat,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: (AssetImage(
                                'assets/more_icon/construction.png')),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      SizedBox(
                        width: sizeu.width - 70 - 20 - 20 - 20 - 10,
                        child: Text(
                          'Skill dan Bahasa',
                          style: TextStyle(
                            color: AppTheme.primaryWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      //delete skill
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/profil_skill_delete');
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: (AssetImage(
                                  'assets/more_icon/remove_file.png')),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),

                      //edit skill
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/profil_skill');
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: (AssetImage(
                                  'assets/more_icon/pen_edit_white.png')),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //content summary
                  SkillNBahasaView(
                    dataSkill: checkData ? dataProfile['skills'] : [],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  checkVar(String array1, String array2) {
    var v = array2 == null ? dataProfile[array1] : dataProfile[array1][array2];
    return (checkData ? v == null ? '-' : v : '-');
  }

  setRekening() {
    String rekening = checkData ? dataProfile['bio']['rekening'] : '-';
    int countRekening = checkData && dataProfile['bio']['rekening'] != null
        ? dataProfile['bio']['rekening'].length
        : 0;

    if (countRekening > 4) {
      return rekening.substring(0, 3) +
          rekening
              .substring(3, countRekening - 2)
              .replaceAll(RegExp(r"."), "*") +
          rekening.substring(countRekening - 2);
    }
    return rekening == null ? '' : rekening;
  }

  Widget contentProfile(String index, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //nama
        Expanded(
            flex: 1,
            child: Text(index,
                style: TextStyle(fontSize: 12, color: Colors.black))),
        Expanded(
            flex: 1,
            child: Text(value,
                style: TextStyle(fontSize: 12, color: Colors.black))),
      ]),
    );
  }
}

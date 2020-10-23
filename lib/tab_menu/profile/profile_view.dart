import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';

class ProfileView extends StatelessWidget {
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
                contentProfile('Nama', 'Suryonono'),
                contentProfile('Tanggal Lahir', '21 Maret 1981'),
                contentProfile('Jenis Kelamin', 'Laki-laki'),
                contentProfile('Kewarganegaraan', 'Indonesia'),
                contentProfile('Telp', '0812371623'),
                contentProfile('Email', 'suryononosuka@gmail.com'),
                contentProfile('Alamat', 'Jl. Kerembung Sawah No.126'),
                contentProfile('Kota', 'Surabaya'),
                contentProfile('Nomor Rekening', '2834*****'),
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
                          Navigator.pushNamed(context, '/profil_summary');
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
                  //content summary
                  Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Text(
                      'Anda belum menambah summary',
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
                color: AppTheme.bgChatBlue,
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
                  Container(
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
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget contentProfile(String index, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(children: [
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

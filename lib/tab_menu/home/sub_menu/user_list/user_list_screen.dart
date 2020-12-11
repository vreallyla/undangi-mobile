import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/search_box.dart';
import 'package:undangi/Constant/shimmer_indicator.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/tab_model.dart';

import 'user_card_view.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  RefreshController _refreshController = RefreshController();

  bool loadingFirst = true;

  int takeRow = 5;
  int takeMore = 5;

  List dataUser = [];

  TextEditingController cariUserInput = new TextEditingController();

  refreshApi(bool kond) {
    setState(() {
      loadingFirst = kond;
    });
  }

  setDataUser(List data) {
    setState(() {
      dataUser = data;
    });
  }

  // refresh user
  void _refreshUser() async {
    GeneralModel.checCk(
        //connect
        () async {
      await GeneralModel.checCk(
          //internet connect
          () {
        TabModel.userData(takeRow.toString(), cariUserInput.text).then((v) {
          if (!loadingFirst) {
            _refreshController.refreshCompleted();
          }

          refreshApi(false);

          if (v.error) {
            errorRespon(context, v.data);
          } else {
            setDataUser(v.data['list']);
          }
        });
      },
          //internet disconnect
          () {
        openAlertBox(context, noticeTitle, notice, konfirm1, () {
          refreshApi(false);

          Navigator.pop(context);
        });
      });
    },
        //disconect
        () {
      if (!loadingFirst) {
        _refreshController.refreshCompleted();
      }

      refreshApi(false);

      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  // refresh user
  void _nextUser() async {
    setState(() {
      takeRow=takeRow+takeMore;
    });
    GeneralModel.checCk(
        //connect
        () async {
      await GeneralModel.checCk(
          //internet connect
          () {
        TabModel.userData(takeRow.toString(), cariUserInput.text).then((v) {
          

          refreshApi(false);

          if (v.error) {
            errorRespon(context, v.data);
          } else {
            setDataUser(v.data['list']);
          }
          if (!loadingFirst) {
                      _refreshController.loadComplete();

          }
        });
      },
          //internet disconnect
          () {
        openAlertBox(context, noticeTitle, notice, konfirm1, () {
          refreshApi(false);

          Navigator.pop(context);
        });
      });
    },
        //disconect
        () {
      if (!loadingFirst) {
                  _refreshController.loadComplete();

      }

      refreshApi(false);

      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  @override
  void initState() {
    _refreshUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
        appBar: appPolosBack(paddingPhone, () {
          Navigator.pop(context);
        }),
        body: Container(
          color: AppTheme.primaryBg,
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //search bar
              SearcBox(
                controll: cariUserInput,
                marginn: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                paddingg: EdgeInsets.only(left: 15, right: 15),
                widthh: sizeu.width - 40,
                heightt: 50,
                widthText: sizeu.width - 60 - 30 - 10,
                textL: 45,
                placeholder: "Cari Pekerja yang anda inginkan",
                eventtChange: (v) {
                  print(v);
                  // v is value of textfield
                },
                eventtSubmit: (v) {
                  setState(() {
                    takeRow = 30;
                  });
                  refreshApi(true);
                  _refreshUser();
                },
              ),
              Container(
                height: sizeu.height -
                    paddingPhone.top -
                    paddingPhone.bottom -
                    bottom -
                    170,
                child: loadingFirst
                    ? onLoading2()
                    : (dataUser.length == 0
                        ? dataKosong()
                        : SmartRefresher(
                            header: ShimmerHeader(
                              text: Text(
                                "PullToRefresh",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 22),
                              ),
                              baseColor: AppTheme.bgChatBlue,
                            ),
                            footer: ShimmerFooter(
                              text: Text(
                                "PullToRefresh",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 22),
                              ),
                              noMore: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "AllUserLoaded",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 22),
                                ),
                              ),
                              baseColor: AppTheme.bgChatBlue,
                            ),
                            controller: _refreshController,
                            enablePullUp: true,
                            child: ListView.builder(
                                itemCount: dataUser.length,
                                // itemExtent: 100.0,
                                itemBuilder: (c, i) =>
                                    cardPekerja(dataUser[i], i)),
                            onRefresh: _refreshUser,
                            onLoading: _nextUser,
                          )),
              )
            ],
          ),
        ));
  }

  Widget cardPekerja(data, int i) {
    List<Widget> dataChild = <Widget>[];
    int z = 0;

    if (i > 0) {
      data.forEach((k, v) {
        if (z > 0) {
          dataChild.add(Padding(padding: EdgeInsets.only(left: 10)));
        }
        dataChild.add(UserCardView(
          data: data[k],
        ));
        z++;
      });
    } else {
      data.forEach((v) {
        if (z > 0) {
          dataChild.add(Padding(padding: EdgeInsets.only(left: 10)));
        }
        dataChild.add(UserCardView(
          data: v,
        ));
        z++;
      });
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 10),
      child: Row(
        children: dataChild,
      ),
    );
  }
}

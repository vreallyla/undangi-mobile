import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/search_box.dart';
import 'package:undangi/Constant/shimmer_indicator.dart';
import 'package:undangi/Model/chat_model.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Constant/expanded_viewport.dart';


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController cariUserInput = new TextEditingController();
  TextEditingController chatInput = new TextEditingController();
  RefreshController _refreshController = RefreshController();

  int userLen = 1;
  int userLenPlus = 1;
  int msgLen = 20;
  int msgLenPlus = 20;
  String search;
  int chatTo;

  bool error = false;
  bool userRefresh = false;

  Timer getChat;

  Map dataChat = {};

  @override
  void initState() {
    _loadChat();
    super.initState();
    getChat = Timer.periodic(Duration(seconds: 3), (Timer t) => _loadChat());
  }

  @override
  void dispose() {
    getChat?.cancel();
    super.dispose();
  }

  _loadChat() async {
    if (!error && !userRefresh) {
      Map res = getParams();

      await GeneralModel.checCk(
          //internet connect
          () {
        ChatModel.get(res).then((v) {
          // print(v.data['skills']);
          if (v.error) {
            errorRespon(context, v.data);
            setState(() {
              error = true;
            });
          } else {
            setState(() {
              dataChat = (v.data);
            });
          }
        });
      },
          //internet disconnect
          () {
        openAlertBox(context, noticeTitle, notice, konfirm1, () {
          Navigator.pop(context);
        });
      });
    }
  }

  // refresh user
  void _refreshUser() async {
    refreshApi(true);
    GeneralModel.checCk(
        //connect
        () async {
      Map res = getParams();

      await GeneralModel.checCk(
          //internet connect
          () {
        ChatModel.get(res).then((v) {
          _refreshController.refreshCompleted();
          refreshApi(false);

          if (v.error) {
            errorRespon(context, v.data);
            setState(() {
              error = true;
            });
          } else {
            setState(() {
              dataChat = (v.data);
            });
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
      refreshApi(false);

      _refreshController.refreshCompleted();

      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  // next user
  void _nextUser() async {
    print('cvcc');
    int rowBefor = dataChat.containsKey('user') ? dataChat['user'].length : 0;

    setState(() {
      userLen = userLen + userLenPlus;
    });
    refreshApi(true);
    GeneralModel.checCk(
        //connect
        () async {
      Map res = getParams();

      await GeneralModel.checCk(
          //internet connect
          () {
        ChatModel.get(res).then((v) {
          if (rowBefor < dataChat['user'].length) {
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
          refreshApi(false);

          if (v.error) {
            errorRespon(context, v.data);
            setState(() {
              error = true;
            });
          } else {
            setState(() {
              dataChat = (v.data);
            });
          }
        });
      },
          //internet disconnect
          () {
        openAlertBox(context, noticeTitle, notice, konfirm1, () {
          refreshApi(false);
          _refreshController.loadNoData();

          Navigator.pop(context);
        });
      });
    },
        //disconect
        () {
      refreshApi(false);

      _refreshController.loadNoData();

      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  refreshApi(bool kond) {
    setState(() {
      userRefresh = kond;
    });
  }

  getParams() {
    Map res = {
      "len_chat": msgLen.toString(),
      // "chat_id":
      "len_user": userLen.toString()
    };
    if (search != null) {
      res['q'] = search;
    }

    if (chatTo != null) {
      res['chat_id'] = chatTo;
    }

    return res;
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
          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          color: AppTheme.primaryBg,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              userBox(sizeu),
              // Padding(padding: EdgeInsets.only(left: 10)),
              chatBox(sizeu, paddingPhone, bottom)
            ],
          )),
    );
  }

  Widget userBox(sizeu) {
    final paddingPhone = MediaQuery.of(context).padding;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      width: 160,
      padding: EdgeInsets.only(right: 10),

      alignment: Alignment.topLeft,
      height: sizeu.height,
      // color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearcBox(
            controll: cariUserInput,
            marginn: EdgeInsets.only(top: 0),
            paddingg: EdgeInsets.only(left: 5, right: 5),
            widthh: 160,
            heightt: 40,
            widthText: 100,
            textL: 15,
            placeholder: "Cari User",
            eventtChange: (v) {
              print(v);
              // v is value of textfield
            },
            eventtSubmit: (v) {
              // v is value of textfield
            },
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8, top: 8),
            child: Text(
              'USER',
              style: TextStyle(
                  color: AppTheme.geyCustom,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
              height: sizeu.height -
                  paddingPhone.top -
                  paddingPhone.bottom -
                  bottom -
                  165,
              width: double.infinity,
              child: SmartRefresher(
                header: ShimmerHeader(
                  text: Text(
                    "PullToRefresh",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  baseColor: AppTheme.bgChatBlue,
                ),
                footer: ShimmerFooter(
                  text: Text(
                    "PullToRefresh",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  noMore: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "AllUserLoaded",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  baseColor: AppTheme.bgChatBlue,
                ),
                controller: _refreshController,
                enablePullUp: true,
                child: ListView.builder(
                    itemCount: dataChat.containsKey('user')
                        ? dataChat['user'].length
                        : 0,
                    // itemExtent: 100.0,
                    itemBuilder: (c, i) => userChat(dataChat['user'][i])),
                onRefresh: _refreshUser,
                onLoading: _nextUser,
              ))
        ],
      ),
    );
  }

  Widget userChat(data) {
    return InkWell(
      onTap: (){
        setState(() {
          chatTo=data['id'];
        });
      },
          child: Container(
            color:chatTo==data['id']? AppTheme.bgBlue2Soft:Colors.transparent,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.only(top:5,bottom:5),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: data.containsKey('foto') && data['foto'] != null
                  ? CachedNetworkImage(
                      imageUrl: domainChange(data['foto']),
                      imageBuilder: (context, imageProvider) => Container(
                        width: 35.0,
                        height: 35.0,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: AppTheme.geySoftCustom),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => SizedBox(
                          width: 80, child: new CircularProgressIndicator()),
                      errorWidget: (context, url, error) => new Icon(Icons.error),
                    )
                  : Image.asset('assets/general/photo_holder.png'),
            ),
            SizedBox(
              width: 110,
              child: Text(
                data['name'],
                maxLines: 2,
                style: TextStyle(fontSize: 11),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget chatBox(sizeu, paddingPhone, bottom) {
    double widthChat = sizeu.width - 170 - 10;
    double widthIco = 30;
    return Stack(
      children: [
        Container(
          width: widthChat,
          height: sizeu.height,
          margin: EdgeInsets.only(top: 60),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: .5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                // content chat
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  height: sizeu.height -
                      100 -
                      20 -
                      70 -
                      bottom -
                      paddingPhone.top -
                      paddingPhone.bottom,
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 30,
                        width: (widthChat - 20) / 2 + 40,
                        margin: EdgeInsets.only(
                            left: (widthChat - 20) / 2 - 40, bottom: 10),
                        decoration: BoxDecoration(
                          color: AppTheme.bgChatGrey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              image: DecorationImage(
                                image: (AssetImage(
                                    'assets/general/user_place.png')),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            height: 30,
                            width: (widthChat - 20) / 2 + 40,
                            margin: EdgeInsets.only(bottom: 10, top: 5),
                            decoration: BoxDecoration(
                              color: AppTheme.bgChatBlue,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // type chat
                Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(width: .5, color: Colors.grey),
                    ),
                  ),
                  child: TextField(
                    onChanged: (v) {
                      // widget.eventtChange(v);
                    },
                    onSubmitted: (v) {
                      // widget.eventtSubmit(v);
                    },
                    maxLength: 120,
                    controller: chatInput,
                    // focusNode: focusCariKategori,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: 'Tulis Pesan ...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: AppTheme.textBlue),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        // head chat
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          height: 60,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
            color: AppTheme.bgChatBlue,
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: (AssetImage('assets/more_icon/chat_icon.png')),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                width: widthIco,
              ),
              SizedBox(
                width: widthChat - widthIco - 20 - 10,
                child: Text(
                  'NillaSanti',
                  maxLines: 1,
                  style: TextStyle(
                      color: AppTheme.primaryWhite,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

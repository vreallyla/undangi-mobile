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
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController cariUserInput = new TextEditingController();
  TextEditingController chatInput = new TextEditingController();
  RefreshController _refreshController = RefreshController();
  RefreshController _chatContentController = RefreshController();
  ScrollController _scrollContentController = ScrollController();

  int userLen = 1;
  int userLenPlus = 1;
  int msgLen = 5;
  int msgLenPlus = 5;
  String search;
  int chatTo;
  double typingHeight = 0;
  String namaChat = '';

  bool error = false;
  bool userRefresh = false;
  bool loadingChat = false;

  Timer getChat;

  Map dataChat = {};
  List dataContent = [];

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
              if(dataChat!=v.data){
                msgLen=msgLen+1;
              }
              dataChat = (v.data);
              if (dataChat['typing']) {
                typingHeight = 40;
              } else {
                typingHeight = 0;
              }
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
              if(dataChat!=v.data){
                msgLen=msgLen+1;
              }
              dataChat = (v.data);
              if (dataChat['typing']) {
                typingHeight = 40;
              } else {
                typingHeight = 0;
              }
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
              if(dataChat!=v.data){
                msgLen=msgLen+1;
              }
              dataChat = (v.data);
              if (dataChat['typing']) {
                typingHeight = 40;
              } else {
                typingHeight = 0;
              }
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

  // change msg to other user
  void _changetMsg() async {
    int rowBefor = dataChat.containsKey('user') ? dataChat['user'].length : 0;
    changeChat(true);

    refreshApi(true);
    GeneralModel.checCk(
        //connect
        () async {
      Map res = getParams();

      await GeneralModel.checCk(
          //internet connect
          () {
        ChatModel.get(res).then((v) {
          refreshApi(false);
          changeChat(false);

          if (v.error) {
            errorRespon(context, v.data);
            setState(() {
              error = true;
            });
          } else {
            setState(() {
              if(dataChat!=v.data){
                msgLen=msgLen+1;
              }
              dataChat = (v.data);
              if (dataChat['typing']) {
                typingHeight = 40;
              } else {
                typingHeight = 0;
              }
            });
          }
        });
      },
          //internet disconnect
          () {
        openAlertBox(context, noticeTitle, notice, konfirm1, () {
          refreshApi(false);
          changeChat(false);

          Navigator.pop(context);
        });
      });
    },
        //disconect
        () {
      refreshApi(false);
      changeChat(false);

      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  void _nextMsg() async {
    int rowBefor = dataChat.containsKey('user') ? dataChat['user'].length : 0;

    setState(() {
      msgLen = msgLen + msgLenPlus;
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
            _chatContentController.loadComplete();
          } else {
            _chatContentController.loadNoData();
          }

          refreshApi(false);

          if (v.error) {
            errorRespon(context, v.data);
            setState(() {
              error = true;
            });
          } else {
            setState(() {
              if(dataChat!=v.data){
                msgLen=msgLen+1;
              }
              dataChat = (v.data);
              if (dataChat['typing']) {
                typingHeight = 40;
              } else {
                typingHeight = 0;
              }
            });
          }
        });
      },
          //internet disconnect
          () {
        openAlertBox(context, noticeTitle, notice, konfirm1, () {
          refreshApi(false);

          _chatContentController.loadNoData();

          Navigator.pop(context);
        });
      });
    },
        //disconect
        () {
      refreshApi(false);

      _chatContentController.loadNoData();

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

  changeChat(bool kond) {
    setState(() {
      loadingChat = kond;
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
              setState(() {
                search=v
;              });
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
      onTap: () {
        setState(() {
          chatTo = data['id'];
          namaChat = data['name'];
        });
        _changetMsg();
      },
      child: Container(
        color: chatTo == data['id'] ? AppTheme.bgBlue2Soft : Colors.transparent,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.only(top: 5, bottom: 5),
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
                          border: Border.all(
                              width: 1, color: AppTheme.geySoftCustom),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => SizedBox(
                          width: 80, child: new CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
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
                      paddingPhone.bottom -
                      typingHeight,
                  child: loadingChat
                      ? onLoading2()
                      : SmartRefresher(
                          enablePullDown: false,
                          onLoading: _nextMsg,
                          footer: CustomFooter(
                            loadStyle: LoadStyle.ShowAlways,
                            builder: (context, mode) {
                              if (mode == LoadStatus.loading) {
                                return Container(
                                  height: 60.0,
                                  child: Container(
                                      height: 20.0,
                                      width: 20.0,
                                      child: loadingCircle()),
                                );
                              } else if (mode == LoadStatus.noMore) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Text('No message more...'),
                                );
                              } else
                                return Container(
                                  height: 0,
                                );
                            },
                          ),
                          enablePullUp: true,
                          child: Scrollable(
                            controller: _scrollContentController,
                            axisDirection: AxisDirection.up,
                            viewportBuilder: (context, offset) {
                              return ExpandedViewport(
                                offset: offset,
                                axisDirection: AxisDirection.up,
                                slivers: <Widget>[
                                  SliverExpanded(),
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (c, i) => dataChat.containsKey('chat')
                                            ? opChat(dataChat['chat'][i])
                                            : Text(''),
                                        childCount: dataChat.containsKey('chat')
                                            ? dataChat['chat'].length
                                            : 0),
                                  )
                                ],
                              );
                            },
                          ),
                          controller: _chatContentController,
                        ),
                ),

                Container(
                  height: typingHeight,
                  alignment: Alignment.center,
                  color: AppTheme.cardBlue,
                  child: Text(
                    typingHeight > 0 ? namaChat + ' typing' : '',
                    style: TextStyle(fontSize: typingHeight > 0 ? 11 : 0),
                  ),
                ),
                // type chat
                Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: chatTo != null && !loadingChat
                        ? Colors.white
                        : AppTheme.geySofttCustom,
                    border: Border(
                      top: BorderSide(width: .5, color: Colors.grey),
                    ),
                  ),
                  child: TextField(
                    enabled: chatTo != null && !loadingChat,
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
                  namaChat,
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

  Widget opChat(data) {
    final sizeu = MediaQuery.of(context).size;

    return data['is_me'] == 1 ? chatMe(data) : chatEnemy(data);
  }

  Widget chatMe(Map data) {
    final sizeu = MediaQuery.of(context).size;
    final he = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(data['created_at']);

    double widthChat = sizeu.width - 170 - 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(5),
          width: (widthChat - 20) / 2 + 40,
          margin: EdgeInsets.only(left: (widthChat - 20) / 2 - 40),
          decoration: BoxDecoration(
            color: AppTheme.bgChatGrey,
            borderRadius: BorderRadius.circular(15),
          ),
          child: data.containsKey('message')
              ? Text(
                  data['message'],
                  style: TextStyle(color: Colors.white),
                )
              : Container(
                  color: Colors.white,
                  child: imageLoad(data['image'], false, 100, 100),
                ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(
              bottom: 10, left: (widthChat - 20) / 2 - 40 + 5, top: 5),
          child: Text(
            new DateFormat('E | d MMM yy').add_jm().format(he) 
                ,
            style: TextStyle(fontSize: 11),
          ),
        )
      ],
    );
  }

  Widget chatEnemy(Map data) {
    final sizeu = MediaQuery.of(context).size;
    final he = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(data['created_at']);

    double widthChat = sizeu.width - 170 - 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 35,
              height: 35,
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: imageLoad(data['foto'], true, 35, 35),
            ),
            Container(
              padding: EdgeInsets.all(5),
              width: (widthChat - 20) / 2 + 40,
              margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: AppTheme.bgChatBlue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: data.containsKey('message')
                  ? Text(
                      data['message'],
                      style: TextStyle(color: Colors.white),
                    )
                  : Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      child:
                          imageLoad(data['image'], false, 80, double.infinity),
                    ),
            ),
          ],
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(bottom: 10, left: 45, top: 5),
          child: Text(
            new DateFormat('E | d MMM yy').add_jm().format(he)
                ,
            style: TextStyle(fontSize: 11),
          ),
        )
      ],
    );
  }
}

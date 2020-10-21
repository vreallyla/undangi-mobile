import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/search_box.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController cariUserInput = new TextEditingController();
  TextEditingController chatInput = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;

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
              chatBox(sizeu, paddingPhone)
            ],
          )),
    );
  }

  Widget userBox(sizeu) {
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
            child: Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: (AssetImage('assets/general/user_place.png')),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 110,
                  child: Text(
                    'Placeholder Nama ',
                    maxLines: 2,
                    style: TextStyle(fontSize: 11),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget chatBox(sizeu, paddingPhone) {
    double widthChat = sizeu.width - 170 - 10;
    double widthIco = 30;
    return SizedBox(
      width: widthChat,
      height: sizeu.height,
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
            // content chat
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              height: sizeu.height -
                  100 -
                  20 -
                  70 -
                  paddingPhone.top -
                  paddingPhone.bottom,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            image:
                                (AssetImage('assets/general/user_place.png')),
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
    );
  }
}

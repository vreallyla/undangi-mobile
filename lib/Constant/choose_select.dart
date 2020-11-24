import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/profile_model.dart';

class ChooseSelect extends StatefulWidget {
  @override
  _ChooseSelectState createState() => _ChooseSelectState();

  const ChooseSelect(
      {Key key, this.op, this.grup, this.judul, this.setValue, this.url})
      : super(key: key);

  final Map op;
  final bool grup;
  final String judul;
  final String url;
  final Function(Map v) setValue;
}

class _ChooseSelectState extends State<ChooseSelect> {
  bool loading = false;
  TextEditingController cari = new TextEditingController();
  List dataOp = [];

  @override
  void initState() {
    super.initState();
    _getApi();
  }

  loadingSet(bool v) {
    setState(() {
      loading = v;
    });
  }

  _getApi() async {
    loadingSet(true);

    await GeneralModel.checCk(

        //connect
        () async {
      String urll = widget.url + ('&q=' + (cari.text ?? ''));
      await ProfileModel.getOp(urll).then((v) {
        loadingSet(false);

        if (v.error) {
          errorRespon(context, v.data);
        } else {
          dataOp = v.data['daftar'];
          addData();
        }
      });
    },
        //disconect
        () {
      loadingSet(false);
      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context);
      });
    });
  }

  List<Widget> dataWidget = <Widget>[];

  addData() {
    dataWidget = <Widget>[];
    setState(() {
      dataOp.forEach((element) {
        if (widget.grup && element.containsKey('sub')) {
          dataWidget.add(signature(element));
          element['sub'].forEach((el) {
            dataWidget.add(selectOrNot(el));
          });
        } else {
          dataWidget.add(selectOrNot(element));
        }
      });
    });
  }

  Widget selectOrNot(Map v) {
    return v.containsKey('selected') && v['selected'] > 0
        ? dataSelected(v)
        : dataNotSelected(v);
  }

  @override
  Widget build(BuildContext context) {
    final paddingPhone = MediaQuery.of(context).padding;
    final wh_ = MediaQuery.of(context).size;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: appPolosBack(paddingPhone, () {
        Navigator.pop(context);
      }),
      body: loading
          ? onLoading2()
          : new GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            width: wh_.width - 51 - 70,
                            child: TextField(
                              controller: cari,
                              onSubmitted: (v) => _getApi(),
                              style: TextStyle(
                                height: .5,
                              ),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: 'Cari disini',
                                  labelText: 'Cari'),
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            child: RaisedButton(
                              color: AppTheme.bgChatBlue,
                              onPressed: () => _getApi(),
                              child: Icon(
                                Icons.search,
                                color: AppTheme.nearlyWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                      height: wh_.height - bottom - 225,
                      decoration: BoxDecoration(
                        color: AppTheme.nearlyWhite,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                      child: ListView(
                        children: dataWidget,
                      ),
                    )
                  ],
                ),
              )),
    );
  }

  Widget signature(Map v) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10, top: 10),
      child: Text(
        v['nama'],
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppTheme.bgChatBlue),
      ),
    );
  }

  Widget dataNotSelected(Map v) {
    return InkWell(
      onTap: () {
        widget.setValue(v);
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 1,
          color: AppTheme.geySofttCustom,
        ))),
        child: Text(
          v['nama'],
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget dataSelected(Map v) {
    return InkWell(
        onTap: () {
          widget.setValue(v);
          Navigator.pop(context);
        },
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            width: 1,
            color: AppTheme.bgChatBlue,
          ))),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  v['nama'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.bgChatBlue,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FaIcon(
                    FontAwesomeIcons.certificate,
                    size: 14,
                    color: AppTheme.bgChatBlue,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

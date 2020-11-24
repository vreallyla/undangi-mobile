import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/profile_model.dart';

class ProfilSummaryScreen extends StatefulWidget {
  @override
  _ProfilSummaryScreenState createState() => _ProfilSummaryScreenState();

  const ProfilSummaryScreen({
    Key key,
    this.summary,
  }) : super(key: key);

  final String summary;
}

class _ProfilSummaryScreenState extends State<ProfilSummaryScreen> {
  TextEditingController summaryInput = new TextEditingController();
  Map error = {};
  setErrorNotif(Map v) {
    setState(() {
      error = v;
    });
  }

  _saveApi() async {
    onLoading(context);

    Map dataSend = {
      "summary": summaryInput.text,
    };
    GeneralModel.checCk(
        //connect
        () async {
      setErrorNotif({});
      ProfileModel.summaryUpdate(dataSend).then((v) {
        Navigator.pop(context);

        if (v.error) {
          if (v.data.containsKey('notValid')) {
            setErrorNotif(v.data['message']);
          } else {
            errorRespon(context, v.data);
          }
        } else {
          Navigator.pop(context, true);
        }
      });
    },
        //disconect
        () {
      Navigator.pop(context);

      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      summaryInput.text = widget.summary;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;

    return new GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: appActionHead(paddingPhone, 'Summary', 'Simpan', () {
          Navigator.pop(context, false);
        }, () {
          //event act save
          _saveApi();
        }),
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Summary',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.topLeft,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(width: .5, color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.primaryBg,
                  ),
                  child: TextField(
                    maxLines: 4,
                    maxLength: 250,
                    onChanged: (v) {
                      // widget.eventtChange(v);
                    },
                    onSubmitted: (v) {
                      // widget.eventtSubmit(v);
                    },
                    // maxLength: widget.textL,
                    controller: summaryInput,
                    // focusNode: focusCariKategori,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText:
                          'Buat Summary semenarik mungkin sehingga klien tertarik bekerja sama denganmu...',
                      border: InputBorder.none,
                      // hintStyle: TextStyle(color: AppTheme.textBlue),
                    ),
                  ),
                ),
                noticeText('summary', error),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WidgetOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/W2');
        },
        child: Container(color: Colors.green));
  }
}

class WidgetTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/W1');
        },
        child: Container(color: Colors.pink));
  }
}

import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/profile_model.dart';

class ProfilSkillView extends StatefulWidget {
  @override
  _ProfilSkillViewState createState() => _ProfilSkillViewState();

  const ProfilSkillView({
    Key key,
    this.skillData,
  }) : super(key: key);

  final List skillData;
}

const List dataSelect = [
  {
    "nama": 'Dasar',
    "value": 'dasar',
  },
  {
    "nama": 'Percakapan',
    "value": 'percakapan',
  },
  {
    "nama": 'Lancar',
    "value": 'lancar',
  },
  {
    "nama": 'Asli (Native)',
    "value": 'asli',
  },
  {
    "nama": 'Pemula',
    "value": 'pemula',
  },
  {
    "nama": 'Menengah',
    "value": 'menengah',
  },
  {
    "nama": 'Ahli',
    "value": 'ahli',
  },
];

const List valueExist = [
  'dasar',
  'percakapan',
  'lancar',
  'asli',
  'pemula',
  'menengah',
  'ahli',
];

class _ProfilSkillViewState extends State<ProfilSkillView> {
  TextEditingController skillInput = new TextEditingController();
  String dropdownValue;
  List skillRes = [];
  List skillNotice = [];
  List<TextEditingController> skillInputs = <TextEditingController>[];
  List<Widget> widgetInput = <Widget>[];
  bool dataFirstLoaded = false;
  Map dataChange = {};

  @override
  void initState() {
    super.initState();
    addAllData();
  }

  void setErrorNotif(List v) {
    setState(() {
      skillNotice.forEach((element) {
        element['nama'] = null;
        element['tingkatan'] = null;
      });

      v.forEach((va) {
        // skillNotice[va['index']]['nama'] = va['nama'];
        // skillNotice[va['index']]['tingkatan'] = va['tingkatan'];
        // skillNotice[v['index']]['nama'] = v['nama'];
        skillNotice[va['index']] = {
          "nama": va['nama'],
          "tingkatan": va['tingkatan']
        };
      });
    });
    print(skillNotice);
  }

  _saveApi() async {
    onLoading(context);

    GeneralModel.checCk(
        //connect
        () async {
      setErrorNotif([]);
      ProfileModel.skillBahasaUpdate(skillRes, valueExist).then((v) {
        Navigator.pop(context);

        if (v.error) {
          if (v.data.containsKey('notValid')) {
            setErrorNotif(v.data['message']);
            openAlertBox(context, noticeTitle, noticeForm, konfirm1, () {
              Navigator.pop(context);
            });
            addAllData();
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

  void loadDataFirst() {
    int i = 0;
    if (widget.skillData.length > 0) {
      widget.skillData.forEach((v) {
        setData(v, i);
        i++;
      });
    } else {
      setData({
        "id": '',
        "nama": '',
        "tingkatan": '',
      }, 0);
    }

    setState(() {});
    print(skillRes);
  }

  void setData(v, i) {
    skillRes.add({
      "id": v['id'],
      "nama": v['nama'],
      "tingkatan": v['tingkatan'],
    });
    skillInputs.add(new TextEditingController());
    skillInputs[i].text = v['nama'];
    skillNotice.add({
      "nama": null,
      "tingkatan": null,
    });
  }

  void addAllData() async {
    if (!dataFirstLoaded) {
      await loadDataFirst();
      setState(() {
        dataFirstLoaded = !dataFirstLoaded;
      });
    }
    widgetInput = <Widget>[];
    int i = 0;
    Widget delimiter(i) {
      if (skillRes.length > 1) {
        return InkWell(
          onTap: () {
            setState(() {
              skillRes.removeAt(i);
              skillInputs.removeAt(i);
              skillNotice.removeAt(i);
            });
            addAllData();
          },
          child: Container(
              margin: EdgeInsets.only(top: 20),
              height: 35,
              color: AppTheme.primaryRed,
              alignment: Alignment.center,
              child: Text(
                'HAPUS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              )),
        );
      } else {
        return Container(
          margin: EdgeInsets.only(top: 20),
          height: 35,
          color: AppTheme.biruLaut,
        );
      }
    }

    skillRes.forEach((v) {
      widgetInput.add(Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: [
            containerInput(
                TextField(
                  onChanged: (value) {
                    setState(() {
                      v['nama'] = value;
                    });
                  },
                  onSubmitted: (value) {
                    // widget.eventtSubmit(v);
                  },
                  maxLength: 80,
                  controller: skillInputs[i],
                  // focusNode: focusCariKategori,
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "Nama Skill",
                    border: InputBorder.none,
                    // hintStyle: TextStyle(color: AppTheme.textBlue),
                  ),
                ),
                20),
            noticeText('nama', skillNotice[i]),
            containerInput(
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "Level",
                    border: InputBorder.none,
                  ),
                  value: valueExist.contains(skillRes[i]['tingkatan'])
                      ? skillRes[i]['tingkatan']
                      : null,
                  items: dataSelect
                      .map<DropdownMenuItem<String>>(
                          (label) => DropdownMenuItem(
                                child: Text(label['nama']),
                                value: label['value'],
                              ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      v['tingkatan'] = value;
                    });
                  },
                ),
                20),
            noticeText('tingkatan', skillNotice[i]),
            delimiter(i)
          ],
        ),
      ));
      i++;
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
        appBar: appActionHead(paddingPhone, 'Skill dan Bahasa', 'Simpan', () {
          Navigator.pop(context);
        }, () {
          //event act save
          _saveApi();
        }),
        body: ListView(
          children: widgetInput,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              setData({
                "id": '',
                "nama": '',
                "tingkatan": '',
              }, skillRes.length);
            });
            addAllData();
          },
          tooltip: 'Tambah skill/bahasa',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget containerInput(Widget chill, double topp) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        margin: EdgeInsets.only(left: 20, right: 20, top: topp),
        decoration: BoxDecoration(
          border: Border.all(width: .5, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 45,
        child: chill);
  }
}

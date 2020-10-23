import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';

class ProfilSkillDeleteView extends StatefulWidget {
  @override
  _ProfilSkillDeleteViewState createState() => _ProfilSkillDeleteViewState();
}

class _ProfilSkillDeleteViewState extends State<ProfilSkillDeleteView> {
  TextEditingController skillInput = new TextEditingController();
  String dropdownValue;

  @override
  Widget build(BuildContext context) {
    // final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;

    return Scaffold(
        appBar: appActionHead(paddingPhone, 'Skill dan Bahasa', 'Simpan', () {
          Navigator.pop(context);
        }, () {
          //event act save
          Navigator.pop(context);
        }),
        body: Container(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
          child: Column(
            children: [
              containerInput(
                  TextField(
                    onChanged: (v) {
                      // widget.eventtChange(v);
                    },
                    onSubmitted: (v) {
                      // widget.eventtSubmit(v);
                    },
                    maxLength: 80,
                    controller: skillInput,
                    // focusNode: focusCariKategori,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "Nama Skill",
                      border: InputBorder.none,
                      // hintStyle: TextStyle(color: AppTheme.textBlue),
                    ),
                  ),
                  20),
              containerInput(
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "Level",
                      border: InputBorder.none,
                    ),
                    value: dropdownValue,
                    items: ["Mahir", "Jago", "Suka"]
                        .map((label) => DropdownMenuItem(
                              child: Text(label),
                              value: label,
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => dropdownValue = value);
                    },
                  ),
                  20),
              Container(
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
                  ))
            ],
          ),
        ));
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

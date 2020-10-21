import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';

class ProfilSkillView extends StatefulWidget {
  @override
  _ProfilSkillViewState createState() => _ProfilSkillViewState();
}

class _ProfilSkillViewState extends State<ProfilSkillView> {
  TextEditingController skillInput = new TextEditingController();
  String dropdownValue;

  @override
  Widget build(BuildContext context) {
    // final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;

    return Scaffold(
        appBar: appActionHead(paddingPhone, 'Skill dan Bahasa', 'Tambah', () {
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
              ),
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
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                height: 35,
                color: AppTheme.biruLaut,
              )
            ],
          ),
        ));
  }

  Widget containerInput(Widget chill) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        decoration: BoxDecoration(
          border: Border.all(width: .5, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 45,
        child: chill);
  }
}

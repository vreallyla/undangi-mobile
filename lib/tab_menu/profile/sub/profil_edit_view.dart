import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';

class ProfilEditView extends StatefulWidget {
  @override
  _ProfilEditViewState createState() => _ProfilEditViewState();
}

class _ProfilEditViewState extends State<ProfilEditView> {
  TextEditingController namaInput = new TextEditingController();
  TextEditingController mottoInput = new TextEditingController();
  TextEditingController tglLahirInput = new TextEditingController();

  TextEditingController noTelpInput = new TextEditingController();
  TextEditingController emailInput = new TextEditingController();
  TextEditingController alamatInput = new TextEditingController();

  TextEditingController noRekInput = new TextEditingController();
  TextEditingController namaPemilikInput = new TextEditingController();

  String jkInput;
  String kewarganegaraanInput;
  String kotaInput;
  String namaBankInput;

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    double _width = sizeu.width;
    // double _height = sizeu.height;
    final paddingPhone = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: appActionHead(paddingPhone, 'Profil', 'Simpan', () {
        Navigator.pop(context);
      }, () {
        //event act save
        Navigator.pop(context);
      }),
      body: Container(
          margin: EdgeInsets.only(top: 25),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //gambar photo
              Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(
                  left: _width / 2 - 50,
                  bottom: 10,
                  right: _width / 2 - 50,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                    image: (AssetImage('assets/general/changwook.jpg')),
                    fit: BoxFit.fitWidth,
                  ),
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
              //tulisan ganti gambar
              SizedBox(
                width: _width,
                child: Text(
                  'Ganti Foto Profil',
                  style: TextStyle(
                    color: AppTheme.textBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              //pembatas
              Padding(padding: EdgeInsets.only(top: 15)),

              //nama
              inputTexfield('Nama', namaInput),

              //MOTTO
              inputTexfield('Motto', mottoInput),

              //TGL LAHIR
              inputTexfield('Tanggal Lahir', tglLahirInput),

              //JK
              inputSelect('Jenis Kelamin', 'Pilih Jenis Kelamin', jkInput,
                  (String v) {
                setState(() {
                  jkInput = v;
                });
              }),

              //kewarganegaraan
              inputSelect(
                  'Kewarganegaraan', 'Pilih Negara', kewarganegaraanInput,
                  (String v) {
                setState(() {
                  kewarganegaraanInput = v;
                });
              }),

              //Telp
              inputTexfield('No. Telp', noTelpInput),

              //email
              inputTexfield('No. Telp', emailInput),

              //alamat
              inputTexfield('Alamat', alamatInput),

              //kota
              inputSelect('Kota/Provinsi', 'Pilih Kota/Provinsi', kotaInput,
                  (String v) {
                setState(() {
                  kotaInput = v;
                });
              }),

              // pembatas biru
              Container(
                height: 25,
                color: AppTheme.primaryBlue,
                margin: EdgeInsets.only(bottom: 10),
              ),

              //BANK
              inputSelect('Bank', 'Bank', kotaInput, (String v) {
                setState(() {
                  kotaInput = v;
                });
              }),

              //NOREK
              inputTexfield('No. Rekening', noRekInput),

              //pemilik rek
              inputTexfield('Nama Pemilik', namaPemilikInput),

              //margin bawah
              Padding(
                padding: EdgeInsets.only(bottom: 25),
              ),
            ],
          )),
    );
  }

  Widget inputTexfield(
    String label,
    TextEditingController controller,
  ) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              label,
              style: TextStyle(
                // color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            height: 50,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: .5, color: AppTheme.geySolidCustom),
                bottom: BorderSide(width: .5, color: AppTheme.geySolidCustom),
              ),
              color: Colors.white,
            ),
            child: TextField(
              decoration: textfieldDesign(''),
              controller: controller,
              maxLength: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget inputSelect(
    String label,
    String placeholder,
    String value,
    Function(String v) changeValue,
  ) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              label,
              style: TextStyle(
                // color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            height: 50,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: .5, color: AppTheme.geySolidCustom),
                bottom: BorderSide(width: .5, color: AppTheme.geySolidCustom),
              ),
              color: Colors.white,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: value,
                onChanged: (String newValue) {
                  setState(() {
                    changeValue(newValue);
                  });
                },
                hint: Text(placeholder,
                    style: TextStyle(color: AppTheme.textBlue, fontSize: 16)),
                icon: Icon(Icons.keyboard_arrow_down),
                items: <String>[
                  'Laki-laki',
                  'Perempuan',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style:
                            TextStyle(color: AppTheme.textBlue, fontSize: 16)),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration textfieldDesign(String hint) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: hint,
      counterStyle: TextStyle(
        height: double.minPositive,
      ),
      counterText: "",
    );
  }
}

import 'package:intl/intl.dart';

//Assets
const String generalAssets = 'assets/general/';

//url
const String domainUrl = '10.0.2.2';
const String globalBaseUrl = 'http://${domainUrl}:8000/api/';
const String globalPathAuth = 'auth/';

//key
const String tokenJWT = 'Bearer ';

//noticec
const String notice = 'Silakan coba lagi...';
const String noticeForm = 'Silakan cek lagi form yang tersedia...';
const String noticeTitle = 'Terjadi kesalahan!';

//CONFIRM
const String konfirm1 = 'OK';
const String cancel1 = 'TIDAK';

//HAPUS
const String titleHapus = 'Yakin Hapus?';
const String subHapus = 'Data akan hilang....';

pointGroup(int value) {
  return NumberFormat("#,###", "id_ID").format(value);
}

decimalPointOne(String value) {
  return NumberFormat("#,##0.0", "id_ID").format(double.parse(value));
}

decimalPointTwo(String value) {
  return NumberFormat("#,##0.00", "id_ID").format(double.parse(value));
}

moreThan99(int val) {
  return val > 99 ? '99+' : val.toString();
}

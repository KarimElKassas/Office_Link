import 'package:easy_localization/easy_localization.dart';

String formatDateTime(String date) {
  var format2 = DateFormat("EEE , d MMM , yyyy hh:mm a" ,"ar");
  var dateString = format2.format(DateTime.parse(date));
  return dateString;
}
String formatDate(String date) {
  var format2 = DateFormat("EEE , d MMM , yyyy" ,"ar");
  var dateString = format2.format(DateTime.parse(date));
  return dateString;
}
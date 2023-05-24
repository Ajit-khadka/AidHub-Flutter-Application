// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

formatDate(String date) {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String formatted = formatter.format(DateTime.parse(date));

  return formatted;
}

String formatedDate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String year = dateTime.year.toString();
  String month = dateTime.month.toString();
  String day = dateTime.day.toString();
  String formattedData = '$day-$month-$year';

  return formattedData;
}

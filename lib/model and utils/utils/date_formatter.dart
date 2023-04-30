// ignore_for_file: depend_on_referenced_packages

import 'package:intl/intl.dart';

formatDate(String date) {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String formatted = formatter.format(DateTime.parse(date));

  return formatted;
}



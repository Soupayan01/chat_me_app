import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDateUtil{
  static String getFormatedTime({required BuildContext context,required String time})
  {
    final date =DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastmsgTime({required BuildContext context,required String time})
  {
    final sent =DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final now=DateTime.now();
    if(now.day==sent.day&&now.month==sent.month&&now.year==sent.year)
      {
        return TimeOfDay.fromDateTime(sent).format(context);
      }
   return'${sent.day}${sent.month}';
}
static String _getmonth(DateTime date) {
  if (date.month == 1) {
    return 'Jan';
  }
  if (date.month == 2) {
    return 'Feb';
  }
  if (date.month == 3) {
    return 'Mar';
  }
  if (date.month == 4) {
    return 'Apr';
  }
  if (date.month == 5) {
    return 'May';
  }
  if (date.month == 6) {
    return 'Jun';
  }
  if (date.month == 7) {
    return 'Jul';
  }
  if (date.month == 8) {
    return 'Aug';
  }
  if (date.month == 9) {
    return 'Sept';
  }
  if (date.month == 10) {
    return 'oct';
  }
  if (date.month == 11) {
    return 'Nov';
  }
  if (date.month == 12) {
    return 'Dec';
  }
  return 'Na';
}
}
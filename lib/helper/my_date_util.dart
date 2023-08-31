import 'package:flutter/material.dart';

class MyDateUtil {
  //for getting formatted time from milliSecondsSinceEpochs String
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

//get formatted last active time of user in chat screen
static String getLastActiveTime(
  {required BuildContext context, required String lastActive}){
  final int i= int.tryParse(lastActive)?? -1;

  // if time is not available then return below statement
  if (i==-1) return'last seen not available';
  DateTime time= DateTime.fromMillisecondsSinceEpoch(i);
  DateTime now=DateTime.now();
  String formattedTime=TimeOfDay.fromDateTime(time).format(context);
  if (time.day==now.day&&time.month==now.month&&time.year==now.year) {
    return 'last seen today at $formattedTime';
  }
  if ((now.difference(time).inHours/24).round()==1) {
    return 'last seen yesterday at $formattedTime';
  }
  String month=_getMonth(time);
  return 'last seen on ${time.day} $month on $formattedTime';
}
//get month name from month no. or index
static String _getMonth(DateTime date){
  switch(date.month){
    case 1: return 'jan';
    case 2: return 'feb';
    case 3: return 'Mar';
    case 4: return 'Apr';
    case 5: return 'May';
    case 6: return 'Jun';
    case 7: return 'Jul';
    case 8: return 'Aug';
    case 9: return 'Sept';
    case 10: return 'Oct';
    case 11: return 'Nov';
    case 12: return 'Dec';

  }
  return 'NA';
}

}

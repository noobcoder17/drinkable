import 'package:flutter/material.dart';

String timeConverter(TimeOfDay time) {
  int hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  int min = time.minute;
  DayPeriod period = time.period;
  String formatedTime = '';
  if(hour<10){
    formatedTime += '0$hour:';
  }else{
    formatedTime += '$hour:';
  }

  if(min<9){
    formatedTime += '0$min ';
  }else{
    formatedTime += '$min ';
  }

  if(period==DayPeriod.am){
    formatedTime += 'AM';
  }else{
    formatedTime += 'PM';
  }
  return formatedTime;
}
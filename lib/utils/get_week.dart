int getWeek(DateTime date){
  int year = date.year;
  DateTime stateDate = DateTime(year,1,1);
  int weekday = stateDate.weekday;
  int days = date.difference(stateDate).inDays; 
  int week = ((weekday+days)/7).ceil();
  return week;
}
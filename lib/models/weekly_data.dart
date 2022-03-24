// utils
import '../utils/get_week.dart';

class WeeklyData {
  String id11;
  int year;
  int month;
  int week;
  Map<String,dynamic> amounts;
  int dailyTarget;

  WeeklyData({
    this.id11,this.year,this.month,this.week,this.amounts,this.dailyTarget
  });

  factory WeeklyData.fromDoc(Map<String,dynamic> doc){
    Map<String,dynamic> rawAmounts = doc.containsKey('amounts') ? doc['amounts'] : {};
    for(int i=1;i<=7;i++){
      if(!rawAmounts.containsKey(i.toString())){
        rawAmounts[i.toString()] = 0;
      }
    }
    return WeeklyData(
      id11: doc['id11'],
      year: doc['year'],
      month: doc['month'],
      week: doc['week'],
      amounts: rawAmounts,
      dailyTarget: doc['daily_target']
    );
  }


  Map<String,dynamic> createNewWeek(String id11,int year,int month,int week,int target){
    return {
      'id11' : id11,
      'year' : year,
      'month' : month,
      'week' : week,
      'daily_target' : target
    };
  }

  double totalThisWeek(){
    double total = 0;
    amounts.forEach((key, value) {
      total+=value;
    });
    return total;
  }

  int percentThisWeek(){
    DateTime today = DateTime.now();
    int thisWeek = getWeek(today);
    double max;
    if(thisWeek==this.week && today.year==this.year){
      max = (dailyTarget*DateTime.now().weekday).toDouble();
    }else{
      max = (dailyTarget*7).toDouble();
    }
    double total = totalThisWeek();
    return ((total/max)*100).toInt();
  }
}
class WeeklyData {
  String id;
  int year;
  int month;
  int week;
  Map<String,dynamic> amounts;
  int dailyTarget;

  WeeklyData({
    this.id,this.year,this.month,this.week,this.amounts,this.dailyTarget
  });

  factory WeeklyData.fromDoc(Map<String,dynamic> doc){
    Map<String,dynamic> rawAmounts = doc.containsKey('amounts') ? doc['amounts'] : {};
    for(int i=1;i<=7;i++){
      if(!rawAmounts.containsKey(i.toString())){
        rawAmounts[i.toString()] = 0;
      }
    }
    return WeeklyData(
      id: doc['id'],
      year: doc['year'],
      month: doc['month'],
      week: doc['week'],
      amounts: rawAmounts,
      dailyTarget: doc['daily_target']
    );
  }


  Map<String,dynamic> createNewWeek(String id,int year,int month,int week,int target){
    return {
      'id' : id,
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
    double total = totalThisWeek();
    double max = (dailyTarget*DateTime.now().weekday).toDouble();
    return ((total/max)*100).toInt();
  }
}
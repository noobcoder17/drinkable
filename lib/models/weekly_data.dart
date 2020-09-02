class WeeklyData {
  String id;
  int year;
  int month;
  int week;
  Map<String,dynamic> amounts;

  WeeklyData({
    this.id,this.year,this.month,this.week,this.amounts
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
      amounts: rawAmounts
    );
  }


  Map<String,dynamic> createNewWeek(String id,int year,int month,int week){
    return {
      'id' : id,
      'year' : year,
      'month' : month,
      'week' : week,
    };
  }
}
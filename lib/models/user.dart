class AppUser {
  String uid;
  String name;
  int dailyTarget;

  AppUser({
    this.uid,
    this.name,
    this.dailyTarget
  });

  factory AppUser.fromDoc(Map<String,dynamic> doc){
    return AppUser(
      uid: doc['uid'],
      name: doc['name'],
      dailyTarget: doc['dailyTarget'] 
    );
  }
}
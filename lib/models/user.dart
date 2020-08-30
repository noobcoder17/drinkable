class User {
  String uid;
  String name;
  int dailyTarget;

  User({
    this.uid,
    this.name,
    this.dailyTarget
  });

  factory User.fromDoc(Map<String,dynamic> doc){
    return User(
      uid: doc['uid'],
      name: doc['name'],
      dailyTarget: doc['dailyTarget'] 
    );
  }
}
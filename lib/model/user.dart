class User {
  String id;
  int age;
  Gender gender;
  String diseases;

  User({required this.id, required this.age, required this.gender, required this.diseases});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      age: json['age'],
      gender: json['gender'],
      diseases: json['diseases']
    );
  }
}

enum Gender {
  male, female, diverse, 
}
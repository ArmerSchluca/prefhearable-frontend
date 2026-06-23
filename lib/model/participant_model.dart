class Participant {
  String id;
  int age;
  Gender gender;
  String diseases;

  Participant({
    required this.id,
    required this.age,
    required this.gender,
    required this.diseases,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'],
      age: json['age'],
      gender: json['gender'],
      diseases: json['diseases'],
    );
  }
}

enum Gender { male, female, diverse }

enum HearingAided { no, leftEar, rightEar, both, duration }

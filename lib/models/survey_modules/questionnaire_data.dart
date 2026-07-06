class QuestionnaireData {
  final Eq5d eq5d;
  final Who5 who5;

  bool get isComplete => eq5d.isComplete && who5.isComplete;

  QuestionnaireData({required this.eq5d, required this.who5});

  Map<String, dynamic> toJson() => {
    'eq5d_responses': eq5d.toJson(),
    'who5_responses': who5.toJson(),
  };
}

class Eq5d {
  final String? question1;

  bool get isComplete => question1 != null;

  Eq5d({required this.question1});

  Map<String, dynamic> toJson() => {'question1': question1};
}

class Who5 {
  final String? question1;

  bool get isComplete => question1 != null;

  Who5({required this.question1});

  Map<String, dynamic> toJson() => {'question1': question1};
}

class Who5 {
  Who5Answer? positiveAffect;
  Who5Answer? calmness;
  Who5Answer? vitality;
  Who5Answer? restedness;
  Who5Answer? lifeInterest;

  bool get isComplete =>
      positiveAffect != null &&
      calmness != null &&
      vitality != null &&
      restedness != null &&
      lifeInterest != null;

  Who5({
    this.positiveAffect,
    this.calmness,
    this.vitality,
    this.restedness,
    this.lifeInterest,
  });

  Map<String, dynamic> toJson() => {
    'positiveAffect': positiveAffect?.value,
    'calmness': calmness?.value,
    'vitality': vitality?.value,
    'restedness': restedness?.value,
    'lifeInterest': lifeInterest?.value,
  };
}

enum Who5Answer { never, rarely, sometimes, often, mostOfTheTime, always }

extension Who5AnswerExtension on Who5Answer {
  String get label {
    switch (this) {
      case Who5Answer.never:
        return "Zu keinem Zeitpunkt";
      case Who5Answer.rarely:
        return "Ab und zu";
      case Who5Answer.sometimes:
        return "Etwas weniger als die Hälfte der Zeit";
      case Who5Answer.often:
        return "Etwas mehr als die Hälfte der Zeit";
      case Who5Answer.mostOfTheTime:
        return "Meistens";
      case Who5Answer.always:
        return "Die ganze Zeit";
    }
  }

  int get value {
    switch (this) {
      case Who5Answer.never:
        return 0;
      case Who5Answer.rarely:
        return 1;
      case Who5Answer.sometimes:
        return 2;
      case Who5Answer.often:
        return 3;
      case Who5Answer.mostOfTheTime:
        return 4;
      case Who5Answer.always:
        return 5;
    }
  }
}

class Eq5d {
  Eq5dLevel? mobility;
  Eq5dLevel? selfCare;
  Eq5dLevel? usualActivities;
  Eq5dLevel? pain;
  Eq5dLevel? anxiety;

  bool get isComplete =>
      mobility != null &&
      selfCare != null &&
      usualActivities != null &&
      pain != null &&
      anxiety != null;

  Eq5d({
    this.mobility,
    this.selfCare,
    this.usualActivities,
    this.pain,
    this.anxiety,
  });

  Map<String, dynamic> toJson() => {
    'mobility': mobility?.value,
    'selfCare': selfCare?.value,
    'usualActivities': usualActivities?.value,
    'pain': pain?.value,
    'anxiety': anxiety?.value,
  };
}

enum Eq5dLevel { level1, level2, level3, level4, level5 }

extension Eq5dLevelExtension on Eq5dLevel {
  int get value {
    switch (this) {
      case Eq5dLevel.level1:
        return 1;
      case Eq5dLevel.level2:
        return 2;
      case Eq5dLevel.level3:
        return 3;
      case Eq5dLevel.level4:
        return 4;
      case Eq5dLevel.level5:
        return 5;
    }
  }
}

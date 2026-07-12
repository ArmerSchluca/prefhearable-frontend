/// Datenmodell für die Cards in der "Vorherige Umfragen"-View
class SurveyOverview {
  final int id;
  final String surveyVersion;
  final DateTime startedAt;
  final DateTime finishedAt;

  SurveyOverview({
    required this.id,
    required this.surveyVersion,
    required this.startedAt,
    required this.finishedAt,
  });

  // Initializer-List, da Felder final sind
  SurveyOverview.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      surveyVersion = json['surveyVersion'],
      startedAt = DateTime.parse(json['startedAt']),
      finishedAt = DateTime.parse(json['finishedAt']);
}

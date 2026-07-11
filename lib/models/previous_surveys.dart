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

  factory SurveyOverview.fromJson(Map<String, dynamic> json) {
    return SurveyOverview(
      id: json['id'],
      surveyVersion: json['survey_version'],
      startedAt: DateTime.parse(json['started_at']),
      finishedAt: DateTime.parse(json['finished_at']),
    );
  }
}
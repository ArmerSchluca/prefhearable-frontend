import 'package:frontend/models/device_information.dart';
import 'package:frontend/models/survey_modules/audiotest_data.dart';
import 'package:frontend/models/survey_modules/context_data.dart';
import 'package:frontend/models/survey_modules/questionnaire_data.dart';
import 'package:frontend/models/survey_modules/personal_data.dart';

/// Datenmodell einer vollständigen Umfrage; umfasst alle erhobenen Daten.
///
/// Das Modell dient sowohl als Arbeitsobjekt innerhalb der App als auch zur
/// Serialisierung für die lokale Zwischenspeicherung und die Übertragung
/// an das Backend.
class Survey {
  final String surveyVersion = "1.0.0";

  DateTime startedAt = DateTime.now();
  DateTime? finishedAt;

  DeviceInformation deviceInformation = DeviceInformation();

  PersonalData personalData = PersonalData();
  ContextData contextData = ContextData();
  QuestionnaireData questionnaireData = QuestionnaireData();
  AudioTestData audioTestData = AudioTestData();

  Survey();

  /// Erstellt eine Umfrage aus einer JSON-Response vom Backend.
  ///
  /// Wird zum Laden einer laufenden Umfrage aus dem SharedStorage verwendet,
  /// sodass beim Schließen der App der Stand gesichert wird und keine Daten verloren gehen.
  Survey.fromJson(Map<String, dynamic> json) {
    startedAt = DateTime.parse(json['startedAt']);
    finishedAt = json['finishedAt'] != null
        ? DateTime.parse(json['finishedAt'])
        : null;
    deviceInformation = DeviceInformation.fromJson(json['deviceInformation']);
    personalData = PersonalData.fromJson(json['personalData']);
    contextData = ContextData.fromJson(json['contextData']);
    questionnaireData = QuestionnaireData.fromJson(json['questionnaireData']);
    audioTestData = AudioTestData.fromJson(json['audioTestData']);
  }

  /// Wandelt die Umfrage in eine JSON-Repräsentation um.
  ///
  /// Wird zum Speichern in den SharedStorage und zur Kommunikation zum Backend verwendet.
  Map<String, dynamic> toJson() => {
    'surveyVersion': surveyVersion,
    'startedAt': startedAt.toIso8601String(),
    'finishedAt': finishedAt?.toIso8601String(),
    'deviceInformation': deviceInformation,
    'personalData': personalData,
    'contextData': contextData,
    'questionnaireData': questionnaireData,
    'audioTestData': audioTestData,
  };

  bool get isComplete =>
      personalData.isComplete &&
      contextData.isComplete &&
      audioTestData.isComplete &&
      questionnaireData.isComplete;
}

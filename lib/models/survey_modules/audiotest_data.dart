import 'package:frontend/models/survey_modules/audio_tests/ccsm.dart';

class AudioTestData {
  CcsmAudioTest ccsm = CcsmAudioTest();

  bool get isComplete => ccsm.isComplete;

  Map<String, dynamic> toJson() => {'ccsm': ccsm.toJson()};
}

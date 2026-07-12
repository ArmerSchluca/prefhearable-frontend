import 'package:frontend/models/survey_modules/audio_tests/ccsm.dart';

class AudioTestData {
  CcsmAudioTest ccsm = CcsmAudioTest();

  AudioTestData();

  bool get isComplete => ccsm.isComplete;

  Map<String, dynamic> toJson() => {'ccsm': ccsm.toJson()};

  AudioTestData.fromJson(Map<String, dynamic> json) {
    ccsm = CcsmAudioTest.fromJson(json['ccsm']);
  }
}

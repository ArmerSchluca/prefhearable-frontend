class AudioTestData {
  CcsmAudioTest ccsm = CcsmAudioTest();

  bool get isComplete => ccsm.isComplete;

  Map<String, dynamic> toJson() => {'ccsm': ccsm};
}

class CcsmAudioTest {
  bool get isComplete => true;
}

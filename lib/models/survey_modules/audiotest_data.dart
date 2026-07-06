class AudioTestData {
  int? age;

  bool get isComplete => age != null;

  AudioTestData({required this.age});

  Map<String, dynamic> toJson() => {'age': age};
}

class CcsmAudioTest {
  
}

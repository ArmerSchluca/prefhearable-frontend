class CcsmAudioTest {
  String? audioDevice;

  SoundRating artificialSound1 = SoundRating();
  SoundRating naturalSound1 = SoundRating();
  SoundRating naturalSound2 = SoundRating();

  CcsmAudioTest();

  bool get isComplete =>
      artificialSound1.isComplete &&
      naturalSound1.isComplete &&
      naturalSound2.isComplete;

  Map<String, dynamic> toJson() => {
    'audioDevice': audioDevice,
    'artificialSound1': artificialSound1.toJson(),
    'naturalSound1': naturalSound1.toJson(),
    'naturalSound2': naturalSound2.toJson(),
  };

  CcsmAudioTest.fromJson(Map<String, dynamic> json) {
    audioDevice = json['audioDevice'];
    artificialSound1 = SoundRating.fromJson(json['artificialSound1']);
    naturalSound1 = SoundRating.fromJson(json['naturalSound1']);
    naturalSound2 = SoundRating.fromJson(json['naturalSound2']);
  }
}

class SoundRating {
  bool hasPlayed;

  int loudness;
  int roughness;
  int tonality;
  int annoyance;
  int sharpness;

  bool get isComplete => hasPlayed;

  SoundRating({
    this.hasPlayed = false,
    this.loudness = 0,
    this.roughness = 0,
    this.tonality = 0,
    this.annoyance = 0,
    this.sharpness = 0,
  });

  Map<String, dynamic> toJson() => {
    'hasPlayed': hasPlayed,
    'loudness': loudness,
    'roughness': roughness,
    'tonality': tonality,
    'annoyance': annoyance,
    'sharpness': sharpness,
  };

  SoundRating.fromJson(Map<String, dynamic> json)
    : hasPlayed = json['hasPlayed'],
      loudness = json['loudness'],
      roughness = json['roughness'],
      tonality = json['tonality'],
      annoyance = json['annoyance'],
      sharpness = json['sharpness'];
}

class FormValidators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Dieses Feld ist erforderlich.";
    }

    return null;
  }

  static String? positiveInteger(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Dieses Feld ist erforderlich.";
    }

    final number = int.tryParse(value);

    if (number == null || number <= 0) {
      return "Bitte eine positive Ganzzahl eingeben.";
    }

    return null;
  }
}
class InputValidator {
  static String? validateAge(int? age) {
    if (age == null) {
      return "Bitte Alter angeben.";
    }

    if (age <= 0) {
      return "Bitte eine positive Ganzzahl eingeben.";
    }

    if (age >= 120 || age <= 5) {
      return "Bitte ein realistisches Alter angeben.";
    }

    return null;
  }

  static String? required(dynamic value) {
    if (value == null) {
      return "Pflichtfeld";
    }

    if (value is String && value.trim().isEmpty) {
      return "Pflichtfeld";
    }

    return null;
  }
}

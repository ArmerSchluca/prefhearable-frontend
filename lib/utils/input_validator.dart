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
}

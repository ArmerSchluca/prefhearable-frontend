import 'package:flutter/material.dart';
import 'package:frontend/models/survey_modules/personal_data.dart';
import 'package:frontend/shared/appbar.dart';
import 'package:frontend/shared/dialogs.dart';
import 'package:frontend/shared/footer.dart';
import 'package:frontend/shared/input_styles.dart';
import 'package:frontend/shared/layout.dart';
import 'package:frontend/utils/input_validator.dart';
import 'package:frontend/utils/survey_instance.dart';

class PersonalDataView extends StatefulWidget {
  const PersonalDataView({super.key});

  @override
  State<PersonalDataView> createState() => _PersonalDataViewState();
}

class _PersonalDataViewState extends State<PersonalDataView> {
  // Zum Mappen der Felder auf das Formular
  final _formKey = GlobalKey<FormState>();

  // TextEditingController observiert die Eingabe und speichert den aktuellen den Wert automatisch
  final ageController = TextEditingController();
  Gender? gender;
  Occupation? occupation;
  HearingAided? hearingAided;
  HearingAidDuration? hearingAidDuration;
  ResidentialArea? residentialArea;
  PhysicalActivityType? physicalActivityType;
  PhysicalActivityFrequency? physicalActivityFrequency;
  PhysicalActivityDuration? physicalActivityDuration;
  Diet? diet;
  final allergiesController = TextEditingController();
  final diseasesController = TextEditingController();

  // Hier werden die Felder mit den bereits gespeicherten Daten befüllt
  @override
  void initState() {
    super.initState();

    final personalData = survey.currentSurvey?.personalData;

    if (personalData != null) {
      ageController.text = personalData.age?.toString() ?? "";
      gender = personalData.gender;
      occupation = personalData.occupation;
      hearingAided = personalData.hearingAided;
      hearingAidDuration = personalData.hearingAidDuration;
      residentialArea = personalData.residentialArea;
      physicalActivityType = personalData.physicalActivityType;
      physicalActivityFrequency = personalData.physicalActivityFrequency;
      physicalActivityDuration = personalData.physicalActivityDuration;
      diet = personalData.diet;
      allergiesController.text = personalData.allergies?.join(", ") ?? "";
      diseasesController.text = personalData.diseases?.join(", ") ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: CustomAppBar(
        title: "Personendaten",
        color: Colors.orange,
        nav: true,
        onBackPressed: () {
          if (!_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Es wurden noch nicht alle Felder ausgefüllt!"),
                backgroundColor: Colors.grey,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Personendaten erfasst!"),
                backgroundColor: Colors.green,
              ),
            );
          }
          _savePersonalData();
          Navigator.pop(context);
        },
      ),
      footer: AppFooter(
        actions: [
          Spacer(),
          // INFO BUTTON
          TextButton.icon(
            icon: Icon(Icons.info, size: 20, color: Colors.blueGrey),
            label: Text(
              "Info",
              style: TextStyle(color: Colors.blueGrey, fontSize: 18),
            ),
            onPressed: () {
              AppDialog.showInfo(context, Text("Titel"), Text("Lorem ipsum"));
            },
          ),
        ],
      ),
      children: [
        Center(child: Icon(Icons.person, size: 150, color: Colors.orange)),
        SizedBox(height: 30),
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            children: [
              // ALTER (age)
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: AppInputStyles.textField(
                  label: "Alter",
                  hint: "z. B. 25",
                  accentColor: Colors.orange,
                ),
                validator: (value) =>
                    InputValidator.validateAge(int.tryParse(value ?? "")),
              ),
              SizedBox(height: 30),

              // GESCHLECHT (gender)
              DropdownButtonFormField<Gender>(
                decoration: AppInputStyles.dropdown(
                  label: "Geschlecht",
                  hint: "Bitte auswählen",
                  accentColor: Colors.orange,
                ),
                initialValue: gender,
                items: Gender.values.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender.label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Bitte Geschlecht auswählen.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // BERUF (occupation)
              DropdownButtonFormField<Occupation>(
                decoration: AppInputStyles.dropdown(
                  label: "Beruf",
                  hint: "Bitte Berufssparte auswählen",
                  accentColor: Colors.orange,
                ),
                initialValue: occupation,
                items: Occupation.values.map((occupation) {
                  return DropdownMenuItem(
                    value: occupation,
                    child: Text(occupation.label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    occupation = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Bitte Beruf auswählen";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // HÖRGERÄTE JA/NEIN (hearingAided)
              DropdownButtonFormField<HearingAided>(
                decoration: AppInputStyles.dropdown(
                  label: "Nutzung von Hörgeräten",
                  hint: "Bitte angeben, ob Sie Hörgeräte nutzen.",
                  accentColor: Colors.orange,
                ),
                initialValue: hearingAided,
                items: HearingAided.values.map((hearingAided) {
                  return DropdownMenuItem(
                    value: hearingAided,
                    child: Text(hearingAided.label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    hearingAided = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Bitte Hörgerätenutzung auswählen";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // HÖRGERÄTE NUTZUNGSZEITRAUM (hearingAidDuration)
              DropdownButtonFormField<HearingAidDuration>(
                decoration: AppInputStyles.dropdown(
                  label: "Zeitraum der Hörgerätenutzung",
                  hint: "Bitte angeben, seit wann Sie Hörgeräte tragen.",
                  accentColor: Colors.orange,
                ),
                initialValue: hearingAidDuration,
                items: HearingAidDuration.values.map((hearingAidDuration) {
                  return DropdownMenuItem(
                    value: hearingAidDuration,
                    child: Text(hearingAidDuration.label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    hearingAidDuration = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Bitte Zeitraum auswählen";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // WOHNRAUM (residentialArea)
              DropdownButtonFormField<ResidentialArea>(
                decoration: AppInputStyles.dropdown(
                  label: "Wohnraum",
                  hint: "Bitte Wohnraum auswählen",
                  accentColor: Colors.orange,
                ),
                initialValue: residentialArea,
                items: ResidentialArea.values.map((residentialArea) {
                  return DropdownMenuItem(
                    value: residentialArea,
                    child: Text(residentialArea.label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    residentialArea = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Bitte Wohnraum auswählen";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // SPORT ART (physicalActivityType)
              DropdownButtonFormField<PhysicalActivityType>(
                decoration: AppInputStyles.dropdown(
                  label: "Sportart",
                  hint: "Bitte Sportart auswählen",
                  accentColor: Colors.orange,
                ),
                initialValue: physicalActivityType,
                items: PhysicalActivityType.values.map((physicalActivityType) {
                  return DropdownMenuItem(
                    value: physicalActivityType,
                    child: Text(physicalActivityType.label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    physicalActivityType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Bitte Sportart auswählen";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // SPORT FREQUENZ (physicalActivityFrequency)
              DropdownButtonFormField<PhysicalActivityFrequency>(
                decoration: AppInputStyles.dropdown(
                  label: "Häufigkeit des Sportmachens",
                  hint: "Bitte Häufigkeit des Sportmachens auswählen",
                  accentColor: Colors.orange,
                ),
                initialValue: physicalActivityFrequency,
                items: PhysicalActivityFrequency.values.map((
                  physicalActivityFrequency,
                ) {
                  return DropdownMenuItem(
                    value: physicalActivityFrequency,
                    child: Text(physicalActivityFrequency.label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    physicalActivityFrequency = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Bitte Häufigkeit auswählen";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // SPORT DAUER (physicalActivityDuration)
              DropdownButtonFormField<PhysicalActivityDuration>(
                decoration: AppInputStyles.dropdown(
                  label: "Dauer einer Sporteinheit",
                  hint: "Bitte Dauer einer Sporteinheit auswählen",
                  accentColor: Colors.orange,
                ),
                initialValue: physicalActivityDuration,
                items: PhysicalActivityDuration.values.map((
                  physicalActivityDuration,
                ) {
                  return DropdownMenuItem(
                    value: physicalActivityDuration,
                    child: Text(physicalActivityDuration.label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    physicalActivityDuration = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Bitte Dauer einer Sporteinheit auswählen";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // ERNÄHRUNG (diet)
              DropdownButtonFormField<Diet>(
                decoration: AppInputStyles.dropdown(
                  label: "Ernährung",
                  hint: "Bitte Ernährungsweise auswählen",
                  accentColor: Colors.orange,
                ),
                initialValue: diet,
                items: Diet.values.map((diet) {
                  return DropdownMenuItem(value: diet, child: Text(diet.label));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    diet = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Bitte Ernährungsweise auswählen";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // ALLERGIEN (allergies)
              TextFormField(
                controller: allergiesController,
                keyboardType: TextInputType.number,
                decoration: AppInputStyles.textField(
                  label: "Allergien",
                  hint: "Mit Komma trennen: Pollen, Nüssen, ...",
                  accentColor: Colors.orange,
                ),
                validator: (_) => null,
              ),
              SizedBox(height: 30),

              // VORERKRANKUNGEN (diseases)
              TextFormField(
                controller: allergiesController,
                keyboardType: TextInputType.number,
                decoration: AppInputStyles.textField(
                  label: "(Vor-)Erkrankungen",
                  hint: "Mit Komma trennen: Diabetes, Asthma, ...",
                  accentColor: Colors.orange,
                ),
                validator: (_) => null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _savePersonalData() async {
    // Alle Eingaben gesammelt in ein Objekt speichern
    final personalData = PersonalData(
      age: int.tryParse(ageController.text),
      gender: gender,
      occupation: occupation,
      hearingAided: hearingAided,
      hearingAidDuration: hearingAidDuration,
      residentialArea: residentialArea,
      physicalActivityType: physicalActivityType,
      physicalActivityFrequency: physicalActivityFrequency,
      physicalActivityDuration: physicalActivityDuration,
      diet: diet,
      // Macht aus den Kommagetrennten Einträgen Listenobjekte
      allergies: allergiesController.text
          .split(RegExp(r'[,;\n]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      diseases: diseasesController.text
          .split(RegExp(r'[,;\n]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
    );

    await survey.savePersonalData(personalData);
  }
}

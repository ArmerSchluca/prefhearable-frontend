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
  int? physicalActivityDuration;
  Diet? diet;
  String? allergies;
  String? diseases;

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
      allergies = personalData.allergies;
      diseases = personalData.diseases;
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
      allergies: allergies,
      diseases: diseases,
    );

    await survey.savePersonalData(personalData);
  }
}

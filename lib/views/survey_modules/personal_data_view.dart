import 'package:flutter/material.dart';
import 'package:frontend/models/personal_data.dart';
import 'package:frontend/services/survey_service.dart';
import 'package:frontend/shared/appbar.dart';
import 'package:frontend/shared/dialogs.dart';
import 'package:frontend/shared/footer.dart';
import 'package:frontend/shared/input_styles.dart';
import 'package:frontend/shared/layout.dart';
import 'package:frontend/utils/form_validator.dart';

class PersonalDataView extends StatefulWidget {
  const PersonalDataView({super.key});

  @override
  State<PersonalDataView> createState() => _PersonalDataViewState();
}

class _PersonalDataViewState extends State<PersonalDataView> {
  final _formKey = GlobalKey<FormState>();

  final ageController = TextEditingController();
  Gender? gender;

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBar: CustomAppBar(
        title: "Personendaten",
        color: Colors.orange,
        nav: true,
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
        Form(
          key: _formKey,
          child: Column(
            children: [
              // ALTER
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: AppInputStyles.textField(
                  label: "Alter",
                  hint: "z. B. 25",
                  accentColor: Colors.orange,
                ),
                validator: FormValidators.positiveInteger,
              ),

              SizedBox(height: 30),

              // GESCHLECHT
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
                    child: Text(gender.name),
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
            ],
          ),
        ),
      ],
    );
  }

  void _savePersonalData() {

      if (!_formKey.currentState!.validate()) {
          return;
      }

      final personalData = PersonalData(
          age: int.parse(ageController.text),
          gender: gender!,
      );

      SurveyService().savePersonalData(personalData);
  }
}

import 'package:firulapp/components/dtos/event_item.dart';
import 'package:firulapp/constants/constants.dart';
import 'package:firulapp/provider/agenda.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/default_button.dart';
import '../../components/input_text.dart';
import '../../provider/medical_record.dart';
import '../../components/dialogs.dart';
import '../mixins/validator_mixins.dart';
import '../../size_config.dart';

class NewMedicalRecordScreen extends StatefulWidget {
  static const routeName = "/new_medical_records";
  @override
  _NewMedicalRecordScreenState createState() => _NewMedicalRecordScreenState();
}

class _NewMedicalRecordScreenState extends State<NewMedicalRecordScreen>
    with ValidatorMixins {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final df = new DateFormat('dd-MM-yyyy');
  MedicalRecordItem _medicalRecord = new MedicalRecordItem();
  DateTime _medicalRecordDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: _medicalRecordDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null && pickedDate != _medicalRecordDate) {
      setState(() {
        _medicalRecordDate = pickedDate;
        _medicalRecord.consultedAt = _medicalRecordDate.toIso8601String();
      });
    }
  }

  Widget build(BuildContext context) {
    final event = ModalRoute.of(context).settings.arguments as EventItem;
    _medicalRecordDate = event.date;
    if (event.eventId != null) {
      _medicalRecord = Provider.of<MedicalRecord>(
        context,
        listen: false,
      ).getLocalMedicalRecordById(event.eventId);
      if (_medicalRecord != null) {
        _medicalRecordDate = DateTime.parse(_medicalRecord.consultedAt);
      } else {
        _medicalRecord = new MedicalRecordItem();
      }
    } else {
      _medicalRecord.consultedAt = _medicalRecordDate.toIso8601String();
    }
    SizeConfig().init(context);
    final SizeConfig sizeConfig = SizeConfig();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulario Consulta Médica"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: sizeConfig.wp(4.5),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  DateFormat('dd-MM-yyyy')
                                      .format(_medicalRecordDate),
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.calendar_today_outlined),
                                  onPressed: () => _selectDate(context),
                                ),
                              ],
                            ),
                            SizedBox(
                              height:
                                  SizeConfig.getProportionateScreenHeight(25),
                            ),
                            buildVeterinaryFormField(
                              "Veterinaria",
                              "Ingrese el nombre de la veterinaria",
                              TextInputType.name,
                            ),
                            SizedBox(
                                height: SizeConfig.getProportionateScreenHeight(
                                    25)),
                            buildDiagnosticFormField(
                              "Diagnóstico",
                              "Ingrese el diagnóstico de la mascota",
                              TextInputType.multiline,
                            ),
                            SizedBox(
                                height: SizeConfig.getProportionateScreenHeight(
                                    25)),
                            buildTreatmentFormField(
                              "Tratamiento",
                              "Ingrese el tratamiento a seguir",
                              TextInputType.multiline,
                            ),
                            SizedBox(
                                height: SizeConfig.getProportionateScreenHeight(
                                    25)),
                            buildObservationsFormField(
                              "Observaciones",
                              "Ingrese observaciones sobre el diagnostico",
                              TextInputType.multiline,
                            ),
                            SizedBox(
                                height: SizeConfig.getProportionateScreenHeight(
                                    25)),
                            Row(
                              children: [
                                Container(
                                  width: SizeConfig.getProportionateScreenWidth(
                                      150),
                                  child: buildWeightFormField(
                                    "Peso",
                                    TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: SizeConfig.getProportionateScreenWidth(
                                      150),
                                  child: buildHeightFormField(
                                    "Altura",
                                    TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: SizeConfig.getProportionateScreenHeight(
                                    25)),
                            Row(
                              children: [
                                CupertinoSwitch(
                                  value: _medicalRecord.treatmentReminder,
                                  onChanged: (value) {
                                    setState(() {
                                      _medicalRecord.treatmentReminder = value;
                                    });
                                  },
                                ),
                                Text(
                                  "Recordatorio",
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                            SizedBox(
                                height: SizeConfig.getProportionateScreenHeight(
                                    25)),
                            DefaultButton(
                              text: "Guardar",
                              color: Constants.kPrimaryColor,
                              press: () async {
                                final isOK = _formKey.currentState.validate();
                                if (isOK) {
                                  try {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await Provider.of<MedicalRecord>(
                                      context,
                                      listen: false,
                                    ).saveMedicalRecord(_medicalRecord);
                                    await Provider.of<Agenda>(context,
                                            listen: false)
                                        .fetchEvents();
                                    Navigator.pop(context);
                                  } catch (error) {
                                    Dialogs.info(
                                      context,
                                      title: 'ERROR',
                                      content: error.response.data["message"],
                                    );
                                  }
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                            ),
                            event.eventId != null
                                ? Column(
                                    children: [
                                      SizedBox(
                                          height: SizeConfig
                                              .getProportionateScreenHeight(
                                                  25)),
                                      DefaultButton(
                                        text: "Borrar",
                                        color: Colors.white,
                                        press: () async {
                                          final response = await Dialogs.alert(
                                            context,
                                            "¿Estás seguro que desea eliminar?",
                                            "Se borrará el registro de la consulta médica",
                                            "Cancelar",
                                            "Aceptar",
                                          );
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          if (response) {
                                            try {
                                              await Provider.of<MedicalRecord>(
                                                context,
                                                listen: false,
                                              ).delete(_medicalRecord);
                                              await Provider.of<Agenda>(context,
                                                      listen: false)
                                                  .fetchEvents();
                                            } catch (error) {
                                              Dialogs.info(
                                                context,
                                                title: 'ERROR',
                                                content: error
                                                    .response.data["message"],
                                              );
                                            }
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: SizeConfig
                                            .getProportionateScreenHeight(25),
                                      ),
                                    ],
                                  )
                                : SizedBox(
                                    height:
                                        SizeConfig.getProportionateScreenHeight(
                                            25),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildVeterinaryFormField(
      String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      validator: validateTextNotNull,
      value: _medicalRecord.veterinary,
      onChanged: (newValue) => _medicalRecord.veterinary = newValue,
    );
  }

  Widget buildDiagnosticFormField(
      String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      maxLines: 10,
      validator: validateTextNotNull,
      value: _medicalRecord.diagnostic,
      onChanged: (newValue) => _medicalRecord.diagnostic = newValue,
    );
  }

  Widget buildTreatmentFormField(
      String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      maxLines: 10,
      validator: validateTextNotNull,
      value: _medicalRecord.treatment,
      onChanged: (newValue) => _medicalRecord.treatment = newValue,
    );
  }

  Widget buildObservationsFormField(
      String label, String hint, TextInputType tipo) {
    return InputText(
      label: label,
      hintText: hint,
      keyboardType: tipo,
      maxLines: 10,
      value: _medicalRecord.observations,
      onChanged: (newValue) => _medicalRecord.observations = newValue,
    );
  }

  Widget buildWeightFormField(String label, TextInputType tipo) {
    return InputText(
      label: label,
      keyboardType: tipo,
      validator: validateTextNotNull,
      value: _medicalRecord.petWeight == null
          ? ''
          : _medicalRecord.petWeight.toString(),
      onChanged: (newValue) => _medicalRecord.petWeight = int.parse(newValue),
    );
  }

  Widget buildHeightFormField(String label, TextInputType tipo) {
    return InputText(
      label: label,
      keyboardType: tipo,
      validator: validateTextNotNull,
      value: _medicalRecord.petHeight == null
          ? ''
          : _medicalRecord.petHeight.toString(),
      onChanged: (newValue) => _medicalRecord.petHeight = int.parse(newValue),
    );
  }
}

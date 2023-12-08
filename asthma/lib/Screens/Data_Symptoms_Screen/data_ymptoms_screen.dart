import 'dart:typed_data';
import 'package:asthma/Screens/Data_Symptoms_Screen/components/add_textfield.dart';
import 'package:asthma/Services/supabase.dart';
import 'package:asthma/blocs/auth_bloc/auth_bloc.dart';
import 'package:asthma/constants/colors.dart';
import 'package:asthma/extensions/screen_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:screenshot/screenshot.dart';
import 'package:asthma/blocs/asthma_bloc/asthma_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asthma/Services/supabase.dart';

class SymptomTrackerScreen extends StatefulWidget {
  @override
  _SymptomTrackerScreenState createState() => _SymptomTrackerScreenState();
}

class _SymptomTrackerScreenState extends State<SymptomTrackerScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  String selectedSymptom = 'cough';
  String selectedLevel = 'Low';
  TextEditingController symptomsDescriptionsController =
      TextEditingController();

  @override
  void initState() {
    context.read<AsthmaBloc>().add(GetSymptomDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPaltte().white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Symptoms',
          style: TextStyle(color: ColorPaltte().darkBlue),
        ),
        leading: Icon(
          Icons.arrow_back,
          color: ColorPaltte().darkBlue,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                var container = Column(
                  children: [
                    ...allSymptoms.map(
                      (e) => Card(
                          child: Column(
                        children: [
                          Text(e.symptomName!),
                          Text(e.symptomDetails!),
                          Text(e.symptomIntensity!)
                        ],
                      )),
                    )
                  ],
                );
                Uint8List? capturedImage =
                    await screenshotController.captureFromWidget(
                        InheritedTheme.captureAll(
                            context, Material(child: container)),
                        delay: const Duration(seconds: 1));
                await SupabaseServer().saveCaptrueImage(capturedImage);
                // saved(capturedImage);
              },
              icon: Icon(Icons.ios_share, color: ColorPaltte().darkBlue))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Expanded(
          child: ListView(
            children: [
              Container(
                constraints: BoxConstraints(
                    minHeight: 100, maxHeight: context.getWidth()),
                padding: const EdgeInsets.all(12),
                width: context.getWidth(),
                decoration: BoxDecoration(
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Your symptoms',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: ColorPaltte().darkBlue),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            showButtonSheet(context);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: ColorPaltte().newDarkBlue,
                              ),
                              Text(
                                'Add Symptom',
                                style: TextStyle(
                                  color: ColorPaltte().newDarkBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: BlocBuilder<AsthmaBloc, AsthmaState>(
                        builder: (context, state) {
                          if (state is SuccessGetSymptomState) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.symptoms.length,
                              itemBuilder: (context, index) {
                                final symptom = state.symptoms[index];
                                return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              shape: BoxShape.rectangle,
                                              color: ColorPaltte().lightBlue,
                                            ),
                                            child: const Icon(
                                              Icons.library_books_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                symptom.symptomName ?? "",
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                symptom.symptomDetails ?? "",
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                symptom.symptomIntensity ?? "",
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              shape: BoxShape.rectangle,
                                              color: Colors.red.shade100,
                                            ),
                                            child: Icon(
                                              Icons.delete_outline_rounded,
                                              color: Colors.red.shade400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                              },
                            );
                          } else if (state is ErrorGetState) {
                            const Center(child: Text("Error getting data"));
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)));
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showButtonSheet(BuildContext context) {
    return showModalBottomSheet(
      showDragHandle: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    "Add Symptoms",
                    style: TextStyle(
                        color: ColorPaltte().newDarkBlue,
                        fontSize: 25,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Symptom",
                  style: TextStyle(
                      fontSize: 18,
                      color: ColorPaltte().darkBlue,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: ColorPaltte().newlightBlue,
                      borderRadius: BorderRadius.circular(10)),
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButton(
                    iconDisabledColor: ColorPaltte().darkBlue,
                    iconEnabledColor: ColorPaltte().darkBlue,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(20),
                    value: selectedSymptom,
                    hint: const Text('Select Symptom'),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: [
                      'cough',
                      'shortness of breath',
                      'Disordered sleep',
                    ].map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSymptom = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Symptom Intensity",
                  style: TextStyle(
                      fontSize: 18,
                      color: ColorPaltte().darkBlue,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                      color: ColorPaltte().newlightBlue,
                      borderRadius: BorderRadius.circular(10)),
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButton(
                    iconDisabledColor: ColorPaltte().darkBlue,
                    iconEnabledColor: ColorPaltte().darkBlue,
                    borderRadius: BorderRadius.circular(20),
                    value: selectedLevel,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: ['Low', 'Moderate', 'High'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedLevel = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                AddTextfield(
                  label: 'Details',
                  fieldController: symptomsDescriptionsController,
                  fieldWidth: MediaQuery.of(context).size.width * 0.95,
                  fieldHeight: 135,
                  onlyRead: false,
                  title: 'Details',
                ),
                const SizedBox(height: 16),
                BlocListener<AsthmaBloc, AsthmaState>(
                  listener: (context, state) {
                    if (state is SucsessMessageState) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                      symptomsDescriptionsController.clear();
                      selectedSymptom = 'cough';
                      selectedLevel = 'Low';
                    } else if (state is ADDErrorState) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  child: InkWell(
                    onTap: () {
                      context.read<AsthmaBloc>().add(AddSymptomEvent(
                          selectedSymptom,
                          symptomsDescriptionsController.text,
                          selectedLevel));

                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Container(
                        height: context.getHeight() * 0.04,
                        width: context.getWidth() * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorPaltte().newDarkBlue,
                        ),
                        child: Center(
                          child: Text(
                            'Add',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: ColorPaltte().white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'cancel',
                        style: TextStyle(
                            color: ColorPaltte().darkBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      )),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

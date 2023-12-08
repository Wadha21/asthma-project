import 'dart:typed_data';
import 'package:asthma/Screens/Data_Symptoms_Screen/components/add_textfield.dart';
import 'package:asthma/Services/supabase.dart';
import 'package:asthma/blocs/auth_bloc/auth_bloc.dart';
import 'package:asthma/constants/colors.dart';
import 'package:asthma/extensions/screen_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:screenshot/screenshot.dart';
import 'package:asthma/blocs/asthma_bloc/asthma_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asthma/Services/supabase.dart';

class MedicationTrackerScreen extends StatefulWidget {
  const MedicationTrackerScreen({super.key});

  @override
  _MedicationTrackerScreenState createState() =>
      _MedicationTrackerScreenState();
}

class _MedicationTrackerScreenState extends State<MedicationTrackerScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController medicationNameController = TextEditingController(),
      medicationQuantitysController = TextEditingController(),
      medicationDateController = TextEditingController(),
      medicationDaysController = TextEditingController();

  @override
  void initState() {
    context.read<AsthmaBloc>().add(GetMedicationDataEvent());
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
          'Medications',
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
                    ...allMedication.map(
                      (e) => Card(
                          child: Column(
                        children: [
                          Text(e.medicationName!),
                          Text(e.days!.toString()),
                          Text(e.date!)
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
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints:
                  BoxConstraints(minHeight: 100, maxHeight: context.getWidth()),
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
                        'Your Medication',
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
                              'Add Medication',
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
                        if (state is SuccessGetMedicationState) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.medications.length,
                            itemBuilder: (context, index) {
                              final medication = state.medications[index];
                              return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
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
                                              "name: ${medication.medicationName}",
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              "days to take: ${medication.days.toString()}",
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              "start date: ${medication.date}",
                                              style:
                                                  const TextStyle(fontSize: 16),
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
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add Medication",
                  style: TextStyle(
                      color: ColorPaltte().newDarkBlue,
                      fontSize: 25,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                AddTextfield(
                  label: 'Medication Name',
                  fieldController: medicationNameController,
                  fieldWidth: MediaQuery.of(context).size.width * 0.95,
                  fieldHeight: 55,
                  onlyRead: false,
                  title: 'Medication Name',
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AddTextfield(
                      label: 'Quantity in day',
                      fieldController: medicationQuantitysController,
                      fieldWidth: MediaQuery.of(context).size.width * 0.44,
                      fieldHeight: 55,
                      onlyRead: false,
                      title: 'Quantity in day',
                    ),
                    AddTextfield(
                      label: 'No. of Days to take',
                      fieldController: medicationDaysController,
                      fieldWidth: MediaQuery.of(context).size.width * 0.44,
                      fieldHeight: 55,
                      onlyRead: false,
                      title: 'days',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                AddTextfield(
                  onTapped: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(), //get today's date
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2024));

                    if (pickedDate != null) {
                      print(pickedDate);
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(formattedDate);

                      medicationDateController.text = formattedDate;
                    } else {
                      print("Date is not selected");
                    }
                  },
                  icon: Icon(
                    Icons.date_range,
                    color: ColorPaltte().newDarkBlue,
                  ),
                  label: 'Start Date',
                  fieldController: medicationDateController,
                  fieldWidth: MediaQuery.of(context).size.width,
                  fieldHeight: 55,
                  onlyRead: true,
                  title: 'Start Date',
                ),
                const SizedBox(
                  height: 16,
                ),
                BlocListener<AsthmaBloc, AsthmaState>(
                  listener: (context, state) {
                    if (state is SucsessMessageState) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                      medicationNameController.clear();
                      medicationDaysController.clear();
                      medicationDateController.clear();
                    } else if (state is ADDErrorState) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  child: InkWell(
                    onTap: () {
                      context.read<AsthmaBloc>().add(AddMedicationEvent(
                          medicationNameController.text,
                          int.parse(medicationDaysController.text),
                          medicationDateController.text));

                      Navigator.pop(context);
                    },
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
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'cancel',
                      style: TextStyle(
                          color: ColorPaltte().darkBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:asthma/Screens/Data_Symptoms_Screen/components/add_textfield.dart';
import 'package:asthma/Screens/breathing/componnets/button_widget.dart';
import 'package:asthma/blocs/asthma_bloc/asthma_bloc.dart';
import 'package:asthma/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

TextEditingController medicationNameController = TextEditingController(),
    medicationQuantitysController = TextEditingController(),
    medicationDateController = TextEditingController(),
    medicationDaysController = TextEditingController();

Future<dynamic> showButtonSheet(BuildContext context) {
  return showModalBottomSheet(
    showDragHandle: true,
    useSafeArea: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      return Container(
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.75),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
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
                child: ButtonWidget(
                  widget: const Text(
                    "Add",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPress: () {
                    context.read<AsthmaBloc>().add(AddMedicationEvent(
                        medicationNameController.text,
                        int.parse(medicationDaysController.text),
                        medicationDateController.text));

                    Navigator.pop(context);
                  },
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

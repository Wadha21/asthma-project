import 'package:asthma/constants/colors.dart';
import 'package:flutter/material.dart';

class AddTextfield extends StatelessWidget {
  const AddTextfield({
    super.key,
    required this.label,
    required this.fieldController,
    required this.fieldWidth,
    this.icon,
    this.fieldHeight,
    this.onTapped,
    required this.onlyRead,
    required this.title,
  });
  final String label;
  final TextEditingController fieldController;
  final double? fieldHeight;

  final double fieldWidth;
  final Icon? icon;
  final String title;
  final Function()? onTapped;
  final bool onlyRead;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 18,
                color: ColorPaltte().darkBlue,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            alignment: Alignment.topLeft,
            width: fieldWidth,
            height: fieldHeight,
            decoration: BoxDecoration(
                color: ColorPaltte().newlightBlue,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                  readOnly: onlyRead,
                  onTap: onTapped,
                  cursorColor: ColorPaltte().darkBlue,
                  textAlign: TextAlign.left,
                  controller: fieldController,
                  decoration: InputDecoration(
                    focusedBorder:
                        const UnderlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder:
                        const UnderlineInputBorder(borderSide: BorderSide.none),
                    prefixIcon: icon,
                    iconColor: ColorPaltte().darkBlue,
                    hintText: label,
                    hintStyle: TextStyle(color: ColorPaltte().darkBlue),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

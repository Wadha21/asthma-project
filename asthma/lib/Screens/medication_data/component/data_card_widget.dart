import 'package:asthma/constants/colors.dart';
import 'package:asthma/extensions/screen_dimensions.dart';
import 'package:flutter/material.dart';

class DataCardWidget extends StatelessWidget {
  const DataCardWidget({
    super.key,
    this.textEntry1,
    this.textEntry2,
    this.textEntry3,
    this.deleteTap,
  });

  final String? textEntry1, textEntry2, textEntry3;

  final Function()? deleteTap;
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  shape: BoxShape.rectangle,
                  color: ColorPaltte().newBlue,
                ),
                child: Image.asset('lib/assets/images/pills.png')),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$textEntry1",
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: ColorPaltte().darkBlue),
                  ),
                  Text(
                    "$textEntry2",
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    "$textEntry3",
                    maxLines: 1,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: deleteTap,
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red.shade400,
                ),
              ),
            ),
          ],
        ));
  }
}

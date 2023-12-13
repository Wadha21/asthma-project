import 'package:asthma/helper/imports.dart';
import 'package:google_fonts/google_fonts.dart';

class ContainerWidget extends StatelessWidget {
  const ContainerWidget({
    super.key,
    required this.imageurl,
    required this.title,
    required this.onTap,
  });
  final String imageurl;
  final String title;

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: context.getWidth(divide: 2.6),
        height: context.getWidth(divide: 2.5),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imageurl,
                width: 110,
                height: 110,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                title,
                style: const TextStyle().fieldFont2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

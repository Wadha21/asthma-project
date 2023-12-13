import 'package:asthma/helper/imports.dart';

class NerestHospital extends StatelessWidget {
  const NerestHospital({
    super.key,
    required this.nearestLocations,
  });

  final List<LocationModel> nearestLocations;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AsthmaBloc>();

    return BlocBuilder<AsthmaBloc, AsthmaState>(
        buildWhen: (oldState, newState) {
      if (newState is SuccessHospitalState) {
        return true;
      }
      return false;
    }, builder: (context, state) {
      if (state is SuccessHospitalState) {
        if (state.hospitalsData!.isNotEmpty) {
          return SizedBox(
            height: context.getHeight() * 0.24,
            width: context.getWidth(),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: nearestLocations.length,
              itemBuilder: (context, index) {
                LocationModel location = nearestLocations[index];
                return InkWell(
                  onTap: () async {
                    final latitude = bloc.hospitalData![index].latitude;
                    final longitude = bloc.hospitalData![index].longitude;
                    final url =
                        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                    await launchUrl(Uri.parse(url));
                  },
                  child: SizedBox(
                    width: context.getWidth(divide: 2.2),
                    height: context.getWidth(divide: 1.9),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                'lib/assets/images/Address-bro2.png',
                                width: 80,
                                height: 80,
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                            Text(
                              location.name!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: ColorPaltte().darkBlue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 20,
                                ),
                                Text(
                                  '${(location.distance! / 1000).toStringAsFixed(2)} km',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      }
      return Container();
    });
  }
}

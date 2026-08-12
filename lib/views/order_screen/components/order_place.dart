import 'package:seller_app/views/widgets/normal_text.dart';
import '../../../const/const.dart';

Widget orderPlaceDetails({
  required String title1,
  required String title2,
  required String d1,
  required String d2,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FIX: Removed the redundant string interpolation ("$title1")
            boldText(text: title1, color: purpleColor),
            boldText(text: d1, color: red),
          ],
        ),
        SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FIX: Removed the redundant string interpolation
              boldText(text: title2, color: purpleColor),
              boldText(text: d2, color: fontGrey),
            ],
          ),
        ),
      ],
    ),
  );
}

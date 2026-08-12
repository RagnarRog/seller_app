import 'package:seller_app/const/const.dart';
import 'package:seller_app/views/widgets/normal_text.dart';

Widget dashboardButton(
  BuildContext context, {
  required String title,
  required String count,
  required String icon,
}) {
  // Explicitly typing the size variable
  Size size = MediaQuery.of(context).size;

  return Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                boldText(text: title, size: 16.0),
                boldText(text: count, size: 20.0),
              ],
            ),
          ),
          Image.asset(icon, width: 40.0, color: white),
        ],
      ).box
      .color(purpleColor)
      .rounded
      .size(size.width * 0.4, 80.0)
      .padding(const EdgeInsets.all(8.0))
      .make();
}

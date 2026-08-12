import 'package:seller_app/views/widgets/normal_text.dart';
import '../../const/const.dart';

Widget ourButton({
  required String title,
  Color color = purpleColor,
  VoidCallback? onPress,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      minimumSize: const Size.fromHeight(52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      backgroundColor: color,
      padding: const EdgeInsets.all(12.0),
    ),
    onPressed: onPress,
    child: normalText(text: title, size: 16.0),
  );
}

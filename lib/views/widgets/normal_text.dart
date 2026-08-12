import '../../const/const.dart';

// Fix for normalText
Widget normalText({
  required String text,
  Color color = Colors.white,
  double size = 14.0,
}) {
  return text.text
      .color(color)
      .size(size) // Added size here to match your parameter
      .make();
}

// Fix for boldText
Widget boldText({
  required String text,
  Color color = Colors.white,
  double size = 14.0,
}) {
  return text.text.semiBold.color(color).size(size).make();
}

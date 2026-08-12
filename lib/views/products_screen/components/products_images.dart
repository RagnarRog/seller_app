// import 'package:velocity_x/velocity_x.dart'; // Make sure VelocityX is imported either here or in const.dart
import 'package:seller_app/const/const.dart';

Widget productImages({
  required String label,
  VoidCallback? onPress, // Added explicit type for the tap function
}) {
  return label
      .text
      .bold // Removed the unnecessary string interpolation "$label"
      .color(fontGrey)
      .size(16.0)
      .makeCentered()
      .box
      .color(lightGrey)
      .size(100, 100)
      .roundedSM
      .make()
      .onTap(
        onPress,
      ); // FIX: Actually attached the onPress action so the box is clickable!
}

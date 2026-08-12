import 'package:seller_app/views/widgets/normal_text.dart';

import '../../const/const.dart';

Widget customTextField(
  String shopName,
  String nameHint, {
  label,
  hint,
  isDesc = false,
  controller,
}) {
  return TextFormField(
    style: TextStyle(color: white),
    maxLines: isDesc ? 4 : 1,
    decoration: InputDecoration(
      isDense: true,
      label: normalText(text: userName),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: white),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: white),
      ), // BorderSide // OutlineInputBorder
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: white),
      ), // BorderSide // OutlineInputBorder
      hintText: hint,
      hintStyle: const TextStyle(color: lightGrey),
    ), // InputDecoration
  ); // TextFormField
}

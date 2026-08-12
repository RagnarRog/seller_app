import 'package:get/get.dart';
import 'package:seller_app/controllers/products_controller.dart';
import 'package:seller_app/views/widgets/normal_text.dart';

import '../../../const/const.dart';

Widget productDropdown(
  String hint, // Added String type
  List<String> list,
  RxString dropvalue, // Added RxString type
  ProductsController controller,
) {
  return Obx(
    () =>
        DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                // Specified generic type <String>
                hint: normalText(
                  text: hint,
                  color: fontGrey,
                ), // Removed redundant interpolation
                value: dropvalue.value == '' ? null : dropvalue.value,
                isExpanded: true,
                items: list.map((String e) {
                  // Added String type to map element
                  return DropdownMenuItem<String>(
                    value: e,
                    child: e.text.make(), // Simplified text call
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Explicitly typed newValue
                  if (newValue != null) {
                    if (hint == "Category") {
                      controller.subcategoryvalue.value = "";
                      controller.populateSubcategory(newValue);
                    }
                    dropvalue.value = newValue;
                  }
                },
              ),
            ).box.white
            .padding(const EdgeInsets.symmetric(horizontal: 4))
            .roundedSM
            .make(),
  );
}

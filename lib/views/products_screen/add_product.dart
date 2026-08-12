import 'package:get/get.dart';
import 'package:seller_app/controllers/products_controller.dart';
import 'package:seller_app/views/products_screen/components/products_dropdown.dart';
import 'package:seller_app/views/products_screen/components/products_images.dart';

import '../../const/const.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/normal_text.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductsController>();

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            icon: const Icon(Icons.arrow_back, color: darkGrey),
          ),
          actions: [
            controller.isLoading.value
                ? CircularProgressIndicator()
                : TextButton(
                    onPressed: () async {
                      await controller.uploadProduct(context);
                    },
                    child: boldText(text: save, color: purpleColor),
                  ),
          ],
          title: boldText(text: "Add product", color: fontGrey, size: 16.0),
        ), // AppBar
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                customTextField(
                  "eg. BMW",
                  "Product name",
                  controller: controller.pnameController,
                ),
                10.heightBox,
                customTextField(
                  "eg. Site Product",
                  "Description",
                  isDesc: true,
                  controller: controller.pdescController,
                ),
                10.heightBox,
                customTextField(
                  "eg. \$100",
                  "Price",
                  controller: controller.ppriceController,
                ),
                10.heightBox,

                customTextField(
                  "eg. 20",
                  "Quantity",
                  controller: controller.pquantityController,
                ),
                10.heightBox,
                productDropdown(
                  "Category",
                  controller.categoryList,
                  controller.categoryvalue,
                  controller,
                ),
                10.heightBox,
                productDropdown(
                  "Subcategory",
                  controller.subcategoryList,
                  controller.subcategoryvalue,
                  controller,
                ),
                10.heightBox,
                const Divider(color: white),
                boldText(text: "choose product images"),
                10.heightBox,
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      3,
                      (index) => controller.pImagesList[index] != null
                          ? Image.file(
                              controller.pImagesList[index]!,
                              width: 100,
                            ).onTap(() {
                              controller.pickImage(index, context);
                            })
                          : productImages(label: "${index + 1}").onTap(() {
                              controller.pickImage(index, context);
                            }),
                    ),
                  ),
                ),
                5.heightBox,
                normalText(
                  text: "first image will be your dispay image",
                  color: lightGrey,
                ),
                const Divider(color: white),
                10.heightBox,
                boldText(text: "choose product images"),
                10.heightBox,
                Obx(
                  () => Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(
                      9,
                      (index) => Stack(
                        alignment: Alignment.center,
                        children: [
                          VxBox()
                              .color(
                                Color(
                                  ProductsController.availableColors[index],
                                ),
                              )
                              .roundedFull
                              .size(70, 70)
                              .make()
                              .onTap(() {
                                controller.selectedColorIndex.value = index;
                              }),
                          controller.selectedColorIndex.value == index
                              ? const Icon(Icons.done, color: white)
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ), // Column
        ), // Padding
      ),
    ); // Scaffold
  }
}

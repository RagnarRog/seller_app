import 'package:get/get.dart';
import 'package:seller_app/views/widgets/normal_text.dart';

import '../../const/const.dart';
import '../../controllers/proifle_controller.dart';
import '../widgets/custom_textfield.dart';

class ShopSettings extends StatelessWidget {
  const ShopSettings({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return Obx(
      () => Scaffold(
        backgroundColor: purpleColor,
        appBar: AppBar(
          title: boldText(text: shopSettings, size: 16.0),
          actions: [
            controller.isLoading.value
                ? CircularProgressIndicator()
                : TextButton(
                    onPressed: () async {
                      controller.isLoading(true);
                      try {
                        await controller.updateShop(
                          shopaddress: controller.shopaddressController.text
                              .trim(),
                          shopname: controller.shopnameController.text.trim(),
                          shopmobile: controller.shopMobileController.text
                              .trim(),
                          shopwebsite: controller.shopWebsiteController.text
                              .trim(),
                          shopdesc: controller.shopDescController.text.trim(),
                        );
                        if (!context.mounted) return;
                        VxToast.show(context, msg: "Shop settings updated");
                        Get.back();
                      } catch (error) {
                        if (context.mounted) {
                          VxToast.show(context, msg: error.toString());
                        }
                      } finally {
                        controller.isLoading(false);
                      }
                    },
                    child: normalText(text: save),
                  ),
          ],
        ), // AppBar
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              customTextField(
                shopName,
                nameHint,
                controller: controller.shopnameController,
              ),
              10.heightBox,
              customTextField(
                address,
                shopAddressHint,
                controller: controller.shopaddressController,
              ),
              10.heightBox,
              customTextField(
                mobile,
                shopMobileHint,
                controller: controller.shopMobileController,
              ),
              10.heightBox,
              customTextField(
                website,
                shopWebsiteHint,
                controller: controller.shopWebsiteController,
              ),
              10.heightBox,
              customTextField(
                description,
                shopDescHint,
                isDesc: true,
                controller: controller.shopDescController,
              ),
            ],
          ), // Column
        ),
      ),
    ); // Padding);
  }
}

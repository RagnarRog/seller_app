import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:seller_app/controllers/products_controller.dart';
import 'package:seller_app/views/products_screen/add_product.dart';
import 'package:seller_app/views/products_screen/product_details.dart';
import 'package:seller_app/views/products_screen/edit_product.dart';
import 'package:seller_app/views/widgets/appbar_widgets.dart';
import 'package:seller_app/views/widgets/normal_text.dart';

import '../../const/const.dart';
import '../../const/firebase_consts.dart';
import '../../services/store_services.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductsController());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await controller.getCategories();
          controller.populateCategoryList();
          Get.to(() => const AddProduct());
        },
        backgroundColor: purpleColor,
        child: const Icon(Icons.add),
      ),
      appBar: appbarWidget(products),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(data.length, (index) {
                    // Safety check for the images array
                    var productData =
                        data[index].data() as Map<String, dynamic>;
                    final images = productData['p_imgs'];
                    final hasImages = images is List && images.isNotEmpty;

                    return Card(
                      child: ListTile(
                        onTap: () {
                          Get.to(() => ProductDetails(data: productData));
                        },
                        // Replaced vulnerable image code with safety check
                        leading: hasImages
                            ? Image.network(
                                images.first.toString(),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Icon(Icons.broken_image_outlined),
                                    ),
                              )
                            : Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              ),
                        title: boldText(
                          text: "${data[index]["p_name"]}",
                          color: fontGrey,
                        ),
                        subtitle: Row(
                          children: [
                            normalText(
                              text: "\$ ${data[index]["p_price"]}",
                              color: darkGrey,
                            ),
                            10.widthBox,
                            boldText(
                              text: data[index]["is_featured"] == true
                                  ? "featured"
                                  : "",
                              color: green,
                            ),
                          ],
                        ),
                        trailing: VxPopupMenu(
                          arrowSize: 0.0,
                          menuBuilder: () => Column(
                            children: List.generate(
                              popupMenuTitles.length,
                              (i) => Padding(
                                padding: const EdgeInsets.all(12.0),
                                child:
                                    Row(
                                      children: [
                                        Icon(
                                          popupMenuIcons[i],
                                          color:
                                              productData["featured_id"] ==
                                                      currentUser!.uid &&
                                                  i == 0
                                              ? green
                                              : darkGrey,
                                        ),
                                        10.widthBox,
                                        normalText(
                                          text:
                                              productData['featured_id'] ==
                                                      currentUser!.uid &&
                                                  i == 0
                                              ? 'Remove feature'
                                              : popupMenuTitles[i],
                                          color: darkGrey,
                                        ),
                                      ],
                                    ).onTap(() {
                                      switch (i) {
                                        case 0:
                                          if (productData['is_featured'] ==
                                              true) {
                                            controller.removeFeatured(
                                              data[index].id,
                                            );
                                            VxToast.show(
                                              context,
                                              msg: "Removed",
                                            );
                                          } else {
                                            controller.addFeatured(
                                              data[index].id,
                                            );
                                            VxToast.show(context, msg: "Added");
                                          }
                                          break;
                                        case 1:
                                          Get.to(
                                            () => EditProductScreen(
                                              docId: data[index].id,
                                              data: productData,
                                            ),
                                          );
                                          break;
                                        case 2:
                                          controller.removeProduct(
                                            data[index].id,
                                          );
                                          VxToast.show(
                                            context,
                                            msg: "Product removed",
                                          );
                                          break;
                                        default:
                                      }
                                    }),
                              ),
                            ),
                          ).box.white.rounded.width(200).make(),
                          clickType: VxClickType.singleClick,
                          child: const Icon(Icons.more_vert_rounded),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

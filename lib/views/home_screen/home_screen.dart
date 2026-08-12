import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:seller_app/views/widgets/appbar_widgets.dart';
import 'package:seller_app/views/widgets/dashboard_button.dart';
import 'package:seller_app/views/widgets/normal_text.dart';

import '../../const/const.dart';
import '../../const/firebase_consts.dart';
import '../../services/store_services.dart';
import '../products_screen/product_details.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Please sign in again')));
    }
    return Scaffold(
      appBar: appbarWidget(dashboard),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: StoreServices.getProducts(user.uid),
        builder: (context, productSnapshot) {
          if (!productSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final products = productSnapshot.data!.docs;
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: StoreServices.getOrders(user.uid),
            builder: (context, orderSnapshot) {
              if (!orderSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final orderDocs = orderSnapshot.data!.docs;
              final sales = _vendorSales(orderDocs, user.uid);
              final averageRating = _averageRating(products);
              final popularProducts = [
                ...products,
              ]..sort((a, b) => _wishlistCount(b).compareTo(_wishlistCount(a)));
              return ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      dashboardButton(
                        context,
                        title: productsLabel,
                        count: '${products.length}',
                        icon: icProducts,
                      ),
                      dashboardButton(
                        context,
                        title: orders,
                        count: '${orderDocs.length}',
                        icon: icOrders,
                      ),
                      dashboardButton(
                        context,
                        title: rating,
                        count: averageRating.toStringAsFixed(1),
                        icon: icStar,
                      ),
                      dashboardButton(
                        context,
                        title: totalSales,
                        count: '\$${sales.toStringAsFixed(0)}',
                        icon: icShopSettings,
                      ),
                    ],
                  ),
                  24.heightBox,
                  boldText(text: popular, color: fontGrey, size: 18.0),
                  12.heightBox,
                  if (popularProducts
                      .where((product) => _wishlistCount(product) > 0)
                      .isEmpty)
                    normalText(
                      text: 'No wishlisted products yet',
                      color: darkGrey,
                    )
                  else
                    ...popularProducts
                        .where((product) => _wishlistCount(product) > 0)
                        .map((product) => _PopularProductTile(data: product)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  static int _wishlistCount(
    QueryDocumentSnapshot<Map<String, dynamic>> product,
  ) {
    final wishlist = product.data()['p_wishlist'];
    return wishlist is List ? wishlist.length : 0;
  }

  static double _averageRating(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> products,
  ) {
    if (products.isEmpty) return 0;
    final values = products.map(
      (product) =>
          double.tryParse(product.data()['p_rating']?.toString() ?? '') ?? 0,
    );
    return values.reduce((a, b) => a + b) / products.length;
  }

  static double _vendorSales(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> orders,
    String vendorId,
  ) {
    double total = 0;
    for (final order in orders) {
      final items = order.data()['orders'];
      if (items is! List) continue;
      for (final item in items) {
        if (item is Map && item['vendor_id'] == vendorId) {
          total += double.tryParse(item['tprice']?.toString() ?? '') ?? 0;
        }
      }
    }
    return total;
  }
}

const productsLabel = 'Products';

class _PopularProductTile extends StatelessWidget {
  const _PopularProductTile({required this.data});
  final QueryDocumentSnapshot<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    final product = data.data();
    final images = product['p_imgs'];
    final url = images is List && images.isNotEmpty
        ? images.first.toString()
        : '';
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () => Get.to(() => ProductDetails(data: product)),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: url.isEmpty
              ? const SizedBox(
                  width: 64,
                  height: 64,
                  child: Icon(Icons.image_outlined),
                )
              : Image.network(
                  url,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    width: 64,
                    height: 64,
                    child: Icon(Icons.broken_image_outlined),
                  ),
                ),
        ),
        title: boldText(
          text: product['p_name']?.toString() ?? 'Unnamed product',
          color: fontGrey,
        ),
        subtitle: normalText(
          text: '\$${product['p_price'] ?? 0}',
          color: darkGrey,
        ),
        trailing: normalText(
          text: '${HomeScreen._wishlistCount(data)} ♥',
          color: purpleColor,
        ),
      ),
    );
  }
}

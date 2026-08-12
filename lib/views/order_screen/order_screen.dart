import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:seller_app/views/order_screen/order_details.dart';
import 'package:seller_app/views/widgets/appbar_widgets.dart';
import 'package:seller_app/views/widgets/normal_text.dart';
import "package:intl/intl.dart" as intl;
import '../../const/const.dart';
import '../../const/firebase_consts.dart';
import '../../services/store_services.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(orders),
      body: StreamBuilder(
        stream: StoreServices.getOrders(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: normalText(text: 'No orders yet', color: darkGrey),
            );
          } else {
            var data = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(
                    data.length,
                    (index) {
                      final time = data[index]["order_date"] as Timestamp?;

                      return ListTile(
                        onTap: () {
                          Get.to(() => OrderDetails(data: data[index]));
                        },
                        leading: Image.asset(
                          imgProduct,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        tileColor: textfieldGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: boldText(
                          text: 'Order #${data[index]["order_code"] ?? '—'}',
                          color: purpleColor,
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month,
                                  color: fontGrey,
                                ),
                                10.widthBox,
                                boldText(
                                  text: time == null
                                      ? 'Processing date…'
                                      : intl.DateFormat.yMMMd().format(
                                          time.toDate(),
                                        ),
                                  color: fontGrey,
                                ),
                              ],
                            ), // Row
                            Row(
                              children: [
                                const Icon(Icons.car_crash, color: fontGrey),
                                10.widthBox,
                                boldText(text: unpaid, color: red),
                              ],
                            ), // Row
                            // normalText(text: "\$40.0", color: darkGrey),
                          ],
                        ),
                        trailing: boldText(
                          text: "\$ ${data[index]["total_amount"]}",
                          color: purpleColor,
                          size: 16.0,
                        ),
                      ).box.margin(const EdgeInsets.only(bottom: 4)).make();
                    },
                    // ListTile
                  ), // List.generate
                ), // Column
              ), // SingleChildScrollView
            );
          }
        },
      ), // StreamBuilder
    );
  }
}

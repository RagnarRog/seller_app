// ignore_for_file: deprecated_member_use

import 'package:get/get.dart';
import 'package:seller_app/controllers/orders_controller.dart';
import 'package:seller_app/views/order_screen/components/order_place.dart';
import 'package:seller_app/views/widgets/normal_text.dart';
import 'package:seller_app/views/widgets/our_button.dart';
import "package:intl/intl.dart" as intl;
import '../../const/const.dart';

class OrderDetails extends StatefulWidget {
  final dynamic data;
  const OrderDetails({super.key, this.data});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  // Explicitly typed controller
  OrdersController controller = Get.find<OrdersController>();

  @override
  void initState() {
    super.initState();
    // Assuming 'data' is a DocumentSnapshot, we cast the data to a Map
    controller.getOrders(widget.data.data() as Map<String, dynamic>);
    controller.confirmed.value = widget.data["order_confirmed"];
    controller.ondelivery.value = widget.data["order_on_delivery"] ?? false;
    controller.delivered.value = widget.data["order_delivered"];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            icon: const Icon(Icons.arrow_back, color: darkGrey),
          ),
          title: boldText(text: "Order details", color: fontGrey, size: 16.0),
        ),
        bottomNavigationBar: Visibility(
          visible: !controller.confirmed.value,
          child: SizedBox(
            height: 60,
            width: context.screenWidth,
            child: ourButton(
              color: green,
              onPress: () {
                controller.confirmed(true);
                // FIX: Added named arguments
                controller.changeStatus(
                  title: "order_confirmed",
                  status: true,
                  docId: widget.data.id,
                );
              },
              title: "Confirm Order",
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Visibility(
                  visible: controller.confirmed.value,
                  child:
                      Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              boldText(
                                text: "Order status:",
                                color: purpleColor,
                                size: 16.0,
                              ),
                              SwitchListTile(
                                activeColor: green,
                                value: true,
                                onChanged: null,
                                title: boldText(
                                  text: "Placed",
                                  color: fontGrey,
                                ),
                              ),
                              SwitchListTile(
                                activeColor: green,
                                value: controller.confirmed.value,
                                onChanged: (bool value) {
                                  controller.confirmed.value = value;
                                  // Optional: update status in DB if you want this togglable
                                  controller.changeStatus(
                                    title: "order_confirmed",
                                    status: value,
                                    docId: widget.data.id,
                                  );
                                },
                                title: boldText(
                                  text: "Confirmed",
                                  color: fontGrey,
                                ),
                              ),
                              SwitchListTile(
                                activeColor: green,
                                value: controller.ondelivery.value,
                                onChanged: (bool value) {
                                  controller.ondelivery.value = value;
                                  // FIX: Added named arguments
                                  controller.changeStatus(
                                    title: "order_on_delivery",
                                    status: value,
                                    docId: widget.data.id,
                                  );
                                },
                                title: boldText(
                                  text: "Awaiting",
                                  color: fontGrey,
                                ),
                              ),
                              SwitchListTile(
                                activeColor: green,
                                value: controller.delivered.value,
                                onChanged: (bool value) {
                                  controller.delivered.value = value;
                                  // FIX: Added named arguments
                                  controller.changeStatus(
                                    title: "order_delivered",
                                    status: value,
                                    docId: widget.data.id,
                                  );
                                },
                                title: boldText(
                                  text: "Delivered",
                                  color: fontGrey,
                                ),
                              ),
                            ],
                          ).box
                          .padding(const EdgeInsets.all(8.0))
                          .outerShadowMd
                          .white
                          .border(color: lightGrey)
                          .roundedSM
                          .make(),
                ),
                10.heightBox,
                Column(
                  children: [
                    orderPlaceDetails(
                      d1: widget.data['order_code'].toString(),
                      d2: widget.data['shipping_method'].toString(),
                      title1: "Order Code",
                      title2: "Shipping Method",
                    ),
                    orderPlaceDetails(
                      d1: intl.DateFormat().add_yMd().format(
                        widget.data["order_date"].toDate(),
                      ),
                      d2: widget.data['payment_method'].toString(),
                      title1: "Order Date",
                      title2: "Payment Method",
                    ),
                    orderPlaceDetails(
                      d1:
                          widget.data['payment_status']?.toString() ??
                          'Pending',
                      d2: controller.delivered.value
                          ? 'Delivered'
                          : controller.ondelivery.value
                          ? 'On delivery'
                          : controller.confirmed.value
                          ? 'Confirmed'
                          : 'Order placed',
                      title1: "Payment Status",
                      title2: "Delivery Status",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              boldText(
                                text: "Shipping Address",
                                color: purpleColor,
                              ),
                              "${widget.data['order_by_name']}".text.make(),
                              "${widget.data['order_by_email']}".text.make(),
                              "${widget.data['order_by_address']}".text.make(),
                              "${widget.data['order_by_city']}".text.make(),
                              "${widget.data['order_by_state']}".text.make(),
                              "${widget.data['order_by_phone']}".text.make(),
                              "${widget.data['order_by_postalcode']}".text
                                  .make(),
                            ],
                          ),
                          SizedBox(
                            width: 130.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                boldText(
                                  text: "Total Amount",
                                  color: purpleColor,
                                ),
                                boldText(
                                  text: "\$ ${widget.data["total_amount"]}",
                                  color: red,
                                  size: 16.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).box.outerShadowSm.white.border(color: lightGrey).make(),
                const Divider(),
                10.heightBox,
                boldText(text: "Ordered Products", color: fontGrey, size: 16.0),
                10.heightBox,
                ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.orders.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            orderPlaceDetails(
                              title1: "${controller.orders[index]['title']}",
                              title2:
                                  "\$ ${controller.orders[index]['tprice']}",
                              d1: "${controller.orders[index]['qty']}x",
                              d2: "Refundable",
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Container(
                                width: 30.0,
                                height: 20.0,
                                color: Color(
                                  controller.orders[index]["color"] as int,
                                ),
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ).box.outerShadowMd.white
                    .margin(const EdgeInsets.only(bottom: 5.0))
                    .make(),
                20.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

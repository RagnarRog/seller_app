import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:seller_app/const/firebase_consts.dart';

class OrdersController extends GetxController {
  RxList<dynamic> orders = <dynamic>[].obs;
  RxBool confirmed = false.obs;
  RxBool ondelivery = false.obs;
  RxBool delivered = false.obs;

  void getOrders(Map<String, dynamic> data) {
    orders.clear();
    List<dynamic> ordersList = data["orders"] ?? [];
    for (var item in ordersList) {
      if (item["vendor_id"] == currentUser!.uid) {
        orders.add(item);
      }
    }
  }

  Future<void> changeStatus({
    required String title,
    required bool status,
    required String docId,
  }) async {
    DocumentReference store = firestore.collection(ordersCollection).doc(docId);
    await store.set({title: status}, SetOptions(merge: true));
  }
}

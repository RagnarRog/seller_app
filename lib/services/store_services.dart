import 'package:cloud_firestore/cloud_firestore.dart';
import '../const/firebase_consts.dart';

class StoreServices {
  // Added String type to uid
  static Future<DocumentSnapshot<Map<String, dynamic>>> getProfile(String uid) {
    return firestore.collection(vendorsCollection).doc(uid).get();
  }

  // Added String type to uid
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String uid) {
    return firestore
        .collection(chatsCollection)
        .where('user_ids', arrayContains: uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages(
    String chatId,
  ) {
    return firestore
        .collection(chatsCollection)
        .doc(chatId)
        .collection(messagesCollection)
        .orderBy('created_on')
        .snapshots();
  }

  // Added String type to uid
  static Stream<QuerySnapshot<Map<String, dynamic>>> getOrders(String uid) {
    return firestore
        .collection(ordersCollection)
        .where("vendors", arrayContains: uid)
        .snapshots();
  }

  // Added String type to uid
  static Stream<QuerySnapshot<Map<String, dynamic>>> getProducts(String uid) {
    return firestore
        .collection(productsCollection)
        .where("vendor_id", isEqualTo: uid)
        .snapshots();
  }

  // FIX: Fixed the logic and added String type to uid
  static Stream<QuerySnapshot<Map<String, dynamic>>> getPopularProducts(
    String uid,
  ) {
    return firestore
        .collection(productsCollection)
        .where(
          "vendor_id",
          isEqualTo: uid,
        ) // Usually you want popular products FOR this vendor
        .orderBy(
          "p_wishlist",
          descending: true,
        ) // Sorting by the wishlist field directly
        .snapshots();
  }
}

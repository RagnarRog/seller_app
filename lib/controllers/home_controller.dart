import 'package:get/get.dart';
import '../const/firebase_consts.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getUsername();
  }

  var navIndex = 0.obs;
  var username = '';

  Future<void> getUsername() async {
    final user = currentUser;
    if (user == null) return;
    final profile = await firestore
        .collection(vendorsCollection)
        .doc(user.uid)
        .get();
    username =
        profile.data()?['vendor_name']?.toString() ??
        user.email?.split('@').first ??
        'Seller';
    update();
  }
}

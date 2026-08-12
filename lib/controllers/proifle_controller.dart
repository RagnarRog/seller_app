import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import "package:path/path.dart";
import '../const/const.dart';
import '../const/firebase_consts.dart';

class ProfileController extends GetxController {
  late DocumentSnapshot<Map<String, dynamic>> snapshotData;

  // Explicitly typed as RxString, String, and RxBool to satisfy the strict analyzer
  RxString profileImgPath = ''.obs;
  String profileImageLink = "";
  RxBool isLoading = false.obs;

  // Explicitly typed as TextEditingController
  TextEditingController nameController = TextEditingController();
  TextEditingController oldpassController = TextEditingController();
  TextEditingController newpassController = TextEditingController();

  TextEditingController shopnameController = TextEditingController();
  TextEditingController shopaddressController =
      TextEditingController(); // Fixed spelling here
  TextEditingController shopMobileController = TextEditingController();
  TextEditingController shopWebsiteController = TextEditingController();
  TextEditingController shopDescController = TextEditingController();

  // Added Future<void> return type and BuildContext parameter type
  Future<void> changeImage(BuildContext context) async {
    try {
      final XFile? img = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (img == null) return;
      profileImgPath.value = img.path;
    } on PlatformException catch (e) {
      // ignore: use_build_context_synchronously
      VxToast.show(context, msg: e.toString());
    }
  }

  Future<String> uploadProfileImage() async {
    final user = currentUser;
    if (user == null || profileImgPath.value.isEmpty) {
      throw StateError('Choose an image before uploading.');
    }
    final file = File(profileImgPath.value);
    if (!await file.exists()) {
      throw StateError('The selected image is no longer available.');
    }
    final filename =
        '${DateTime.now().millisecondsSinceEpoch}_${basename(file.path)}';
    final destination = 'profile_images/vendors/${user.uid}/$filename';
    final snapshot = await FirebaseStorage.instance
        .ref(destination)
        .putFile(file);
    profileImageLink = await snapshot.ref.getDownloadURL();
    return profileImageLink;
  }

  Future<void> updateProfile({
    required String name,
    required String imageUrl,
  }) async {
    final user = currentUser;
    if (user == null) throw StateError('You are signed out.');
    await firestore.collection(vendorsCollection).doc(user.uid).set({
      'id': user.uid,
      "vendor_name": name,
      "email": user.email,
      "imageUrl": imageUrl,
    }, SetOptions(merge: true));
  }

  // Added Future<void> return type and required String parameter types for named arguments
  Future<void> changeAuthPassword({
    required String email,
    required String password,
    required String newpassword,
  }) async {
    final user = currentUser;
    if (user == null) throw StateError('You are signed out.');
    final AuthCredential cred = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    await user.reauthenticateWithCredential(cred);
    await user.updatePassword(newpassword);
  }

  // Added Future<void> return type and required String parameter types for named arguments
  Future<void> updateShop({
    required String shopname,
    required String shopaddress,
    required String shopmobile,
    required String shopwebsite,
    required String shopdesc,
  }) async {
    final user = currentUser;
    if (user == null) throw StateError('You are signed out.');
    await firestore.collection(vendorsCollection).doc(user.uid).set({
      'id': user.uid,
      'email': user.email,
      'shop_name': shopname,
      'shop_address': shopaddress,
      'shop_mobile': shopmobile,
      'shop_website': shopwebsite,
      'shop_desc': shopdesc,
    }, SetOptions(merge: true));
  }

  void loadShopFields(Map<String, dynamic> data) {
    shopnameController.text = data['shop_name']?.toString() ?? '';
    shopaddressController.text = data['shop_address']?.toString() ?? '';
    shopMobileController.text = data['shop_mobile']?.toString() ?? '';
    shopWebsiteController.text = data['shop_website']?.toString() ?? '';
    shopDescController.text = data['shop_desc']?.toString() ?? '';
  }

  @override
  void onClose() {
    nameController.dispose();
    oldpassController.dispose();
    newpassController.dispose();
    shopnameController.dispose();
    shopaddressController.dispose();
    shopMobileController.dispose();
    shopWebsiteController.dispose();
    shopDescController.dispose();
    super.onClose();
  }
}

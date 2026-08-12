import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_app/controllers/home_controller.dart';

import '../const/const.dart';
import '../const/firebase_consts.dart';
import '../models/category_model.dart';
import "package:path/path.dart";

class ProductsController extends GetxController {
  static const availableColors = <int>[
    0xFF111827,
    0xFF4F46E5,
    0xFFDC2626,
    0xFF059669,
    0xFFF59E0B,
    0xFF7C3AED,
    0xFFDB2777,
    0xFF0284C7,
    0xFF92400E,
  ];
  RxBool isLoading = false.obs;

  // Explicitly typed Controllers
  TextEditingController pnameController = TextEditingController();
  TextEditingController pdescController = TextEditingController();
  TextEditingController ppriceController = TextEditingController();
  TextEditingController pquantityController = TextEditingController();

  RxList<String> categoryList = <String>[].obs;
  RxList<String> subcategoryList = <String>[].obs;
  List<Category> category = [];

  // FIX: Explicitly typed lists
  List<String> pImagesLinks = [];
  RxList<File?> pImagesList = RxList<File?>.generate(3, (int index) => null);

  RxString categoryvalue = ''.obs;
  RxString subcategoryvalue = ''.obs;
  RxInt selectedColorIndex = 0.obs;

  Future<void> getCategories() async {
    String data = await rootBundle.loadString(
      "lib/services/category_model.json",
    );
    CategoryModel cat = categoryModelFromJson(data);
    category = cat.categories;
  }

  void populateCategoryList() {
    categoryList.clear();
    for (Category item in category) {
      categoryList.add(item.name);
    }
  }

  // Added String type to cat
  void populateSubcategory(String cat) {
    subcategoryList.clear();

    List<Category> data = category
        .where((Category element) => element.name == cat)
        .toList();

    if (data.isNotEmpty) {
      for (String subcat in data.first.subcategory) {
        subcategoryList.add(subcat);
      }
    }
  }

  // Added types to index and context
  Future<void> pickImage(int index, BuildContext context) async {
    try {
      final XFile? img = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (img == null) {
        return;
      } else {
        pImagesList[index] = File(img.path);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      VxToast.show(context, msg: e.toString());
    }
  }

  Future<void> uploadImages() async {
    pImagesLinks.clear();

    // Safety check to ensure we have a user
    if (currentUser == null) return;

    for (File? item in pImagesList) {
      if (item != null) {
        try {
          String filename =
              '${DateTime.now().millisecondsSinceEpoch}_${basename(item.path)}';
          String destination = 'product_images/${currentUser!.uid}/$filename';
          Reference ref = FirebaseStorage.instance.ref().child(destination);
          TaskSnapshot snapshot = await ref.putFile(item);
          String downloadUrl = await snapshot.ref.getDownloadURL();
          pImagesLinks.add(downloadUrl);
        } catch (e) {
          throw StateError('Could not upload a product image: $e');
        }
      }
    }
  }

  Future<void> uploadProduct(BuildContext context) async {
    isLoading(true);

    try {
      if (pnameController.text.trim().isEmpty ||
          ppriceController.text.trim().isEmpty ||
          pquantityController.text.trim().isEmpty ||
          categoryvalue.value.isEmpty ||
          subcategoryvalue.value.isEmpty ||
          pImagesList.every((image) => image == null)) {
        throw StateError('Complete all fields and choose at least one image.');
      }
      await uploadImages();
      DocumentReference store = firestore.collection(productsCollection).doc();
      await store.set({
        'is_featured': false,
        'p_category': categoryvalue.value,
        'p_subcategory': subcategoryvalue.value,
        'p_colors': [availableColors[selectedColorIndex.value]],
        'p_imgs': pImagesLinks, // Directly use the list we populated in step 1
        'p_wishlist': FieldValue.arrayUnion([]),
        'p_desc': pdescController.text,
        'p_name': pnameController.text,
        "p_price": ppriceController.text,
        "p_quantity": pquantityController.text,
        "p_seller": Get.find<HomeController>().username,
        "p_rating": "5.0",
        "vendor_id": currentUser!.uid,
        "featured_id": "",
      });

      // ignore: use_build_context_synchronously
      VxToast.show(context, msg: "Product uploaded successfully");
      clearProductForm();
      Get.back(); // Return to previous screen
    } catch (e) {
      // ignore: use_build_context_synchronously
      VxToast.show(context, msg: e.toString());
    } finally {
      isLoading(false);
    }
  }

  void clearProductForm() {
    pnameController.clear();
    pdescController.clear();
    ppriceController.clear();
    pquantityController.clear();
    categoryvalue.value = '';
    subcategoryvalue.value = '';
    pImagesLinks.clear();
    pImagesList.assignAll(List<File?>.filled(3, null));
    selectedColorIndex.value = 0;
  }

  Future<void> updateProduct({
    required String docId,
    required String name,
    required String description,
    required String price,
    required String quantity,
  }) async {
    if (name.trim().isEmpty ||
        description.trim().isEmpty ||
        double.tryParse(price) == null ||
        int.tryParse(quantity) == null) {
      throw StateError('Enter a valid name, description, price and quantity.');
    }
    await firestore.collection(productsCollection).doc(docId).update({
      'p_name': name.trim(),
      'p_desc': description.trim(),
      'p_price': price.trim(),
      'p_quantity': quantity.trim(),
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  // Added String type to docId
  Future<void> addFeatured(String docId) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'featured_id': currentUser!.uid,
      'is_featured': true,
    }, SetOptions(merge: true));
  }

  // Added String type to docId
  Future<void> removeFeatured(String docId) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'featured_id': '',
      'is_featured': false,
    }, SetOptions(merge: true));
  }

  // Added String type to docId
  Future<void> removeProduct(String docId) async {
    await firestore.collection(productsCollection).doc(docId).delete();
  }

  @override
  void onClose() {
    pnameController.dispose();
    pdescController.dispose();
    ppriceController.dispose();
    pquantityController.dispose();
    super.onClose();
  }
}

import 'package:get/get.dart';
import 'package:seller_app/const/const.dart';
import 'package:seller_app/controllers/products_controller.dart';
import 'package:seller_app/views/widgets/custom_textfield.dart';
import 'package:seller_app/views/widgets/normal_text.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key, required this.docId, required this.data});

  final String docId;
  final Map<String, dynamic> data;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  bool saving = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.data['p_name']?.toString() ?? '';
    descriptionController.text = widget.data['p_desc']?.toString() ?? '';
    priceController.text = widget.data['p_price']?.toString() ?? '';
    quantityController.text = widget.data['p_quantity']?.toString() ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: boldText(text: 'Edit product', color: fontGrey, size: 16.0),
        actions: [
          saving
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(),
                )
              : TextButton(
                  onPressed: _save,
                  child: boldText(text: save, color: purpleColor),
                ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          customTextField(
            'Product name',
            'Product name',
            controller: nameController,
          ),
          12.heightBox,
          customTextField(
            'Description',
            'Description',
            isDesc: true,
            controller: descriptionController,
          ),
          12.heightBox,
          customTextField('Price', 'Price', controller: priceController),
          12.heightBox,
          customTextField(
            'Quantity',
            'Quantity',
            controller: quantityController,
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    setState(() => saving = true);
    try {
      await Get.find<ProductsController>().updateProduct(
        docId: widget.docId,
        name: nameController.text,
        description: descriptionController.text,
        price: priceController.text,
        quantity: quantityController.text,
      );
      if (!mounted) return;
      VxToast.show(context, msg: 'Product updated');
      Get.back();
    } catch (error) {
      if (mounted) VxToast.show(context, msg: error.toString());
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }
}

import 'dart:io';

import 'package:get/get.dart';
import 'package:seller_app/const/const.dart';
import 'package:seller_app/controllers/proifle_controller.dart';
import 'package:seller_app/views/widgets/custom_textfield.dart';
import 'package:seller_app/views/widgets/normal_text.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.username});
  final String username;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final controller = Get.find<ProfileController>();

  Map<String, dynamic> get profileData =>
      controller.snapshotData.data() ?? const <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    controller.nameController.text = widget.username;
    controller.oldpassController.clear();
    controller.newpassController.clear();
    controller.profileImgPath.value = '';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: boldText(text: editProfile, color: fontGrey, size: 16.0),
          actions: [
            controller.isLoading.value
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(),
                  )
                : TextButton(
                    onPressed: () => _save(context),
                    child: boldText(text: save, color: purpleColor),
                  ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(child: _imagePreview()),
            TextButton.icon(
              onPressed: () => controller.changeImage(context),
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Choose profile image'),
            ),
            16.heightBox,
            customTextField(
              userName,
              nameHint,
              controller: controller.nameController,
            ),
            20.heightBox,
            boldText(text: 'Change password (optional)', color: fontGrey),
            10.heightBox,
            customTextField(
              password,
              'Current password',
              controller: controller.oldpassController,
            ),
            10.heightBox,
            customTextField(
              confirmPass,
              'New password',
              controller: controller.newpassController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePreview() {
    if (controller.profileImgPath.value.isNotEmpty) {
      return CircleAvatar(
        radius: 48,
        backgroundImage: FileImage(File(controller.profileImgPath.value)),
      );
    }
    final url = profileData['imageUrl']?.toString() ?? '';
    return CircleAvatar(
      radius: 48,
      backgroundColor: textfieldGrey,
      backgroundImage: url.isEmpty ? null : NetworkImage(url),
      child: url.isEmpty ? const Icon(Icons.store, size: 40) : null,
    );
  }

  Future<void> _save(BuildContext context) async {
    controller.isLoading(true);
    try {
      final oldPassword = controller.oldpassController.text;
      final newPassword = controller.newpassController.text;
      if (oldPassword.isNotEmpty || newPassword.isNotEmpty) {
        if (oldPassword.isEmpty || newPassword.length < 6) {
          throw StateError(
            'Enter your current password and a new password of at least 6 characters.',
          );
        }
        await controller.changeAuthPassword(
          email: profileData['email']?.toString() ?? '',
          password: oldPassword,
          newpassword: newPassword,
        );
      }
      final imageUrl = controller.profileImgPath.value.isNotEmpty
          ? await controller.uploadProfileImage()
          : profileData['imageUrl']?.toString() ?? '';
      await controller.updateProfile(
        name: controller.nameController.text.trim(),
        imageUrl: imageUrl,
      );
      if (!context.mounted) return;
      VxToast.show(context, msg: 'Profile updated');
      Get.back();
    } catch (error) {
      if (context.mounted) VxToast.show(context, msg: error.toString());
    } finally {
      controller.isLoading(false);
    }
  }
}

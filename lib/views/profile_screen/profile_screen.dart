import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:seller_app/const/const.dart';
import 'package:seller_app/controllers/auth_controller.dart';
import 'package:seller_app/controllers/proifle_controller.dart';
import 'package:seller_app/services/store_services.dart';
import 'package:seller_app/views/auth_screen/login_screen.dart';
import 'package:seller_app/views/messages_screen/messages_screen.dart';
import 'package:seller_app/views/profile_screen/edit_profile_screen.dart';
import 'package:seller_app/views/shop_screen/shop_settings.dart';
import 'package:seller_app/views/widgets/normal_text.dart';

import '../../const/firebase_consts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final user = currentUser;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: boldText(text: settings, color: fontGrey, size: 18.0),
        actions: [
          IconButton(
            tooltip: logout,
            onPressed: () async {
              await Get.find<AuthController>().signoutMethod(context);
              Get.offAll(() => const LoginScreen());
            },
            icon: const Icon(Icons.logout, color: purpleColor),
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('Please sign in again'))
          : FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: StoreServices.getProfile(user.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.data!.exists) {
                  return Center(
                    child: normalText(
                      text: 'Profile could not be loaded',
                      color: darkGrey,
                    ),
                  );
                }
                controller.snapshotData = snapshot.data!;
                final data = controller.snapshotData.data() ?? {};
                final imageUrl = data['imageUrl']?.toString() ?? '';
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: _ProfileImage(url: imageUrl),
                        title: boldText(
                          text: data['vendor_name']?.toString() ?? 'Seller',
                          color: fontGrey,
                          size: 17.0,
                        ),
                        subtitle: normalText(
                          text: data['email']?.toString() ?? user.email ?? '',
                          color: darkGrey,
                        ),
                        trailing: IconButton(
                          tooltip: editProfile,
                          onPressed: () => Get.to(
                            () => EditProfileScreen(
                              username: data['vendor_name']?.toString() ?? '',
                            ),
                          ),
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: purpleColor,
                          ),
                        ),
                      ),
                    ),
                    20.heightBox,
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {
                              controller.loadShopFields(data);
                              Get.to(() => const ShopSettings());
                            },
                            leading: const Icon(
                              Icons.storefront_outlined,
                              color: purpleColor,
                            ),
                            title: boldText(
                              text: shopSettings,
                              color: fontGrey,
                            ),
                            subtitle: normalText(
                              text:
                                  data['shop_name']?.toString().isNotEmpty ==
                                      true
                                  ? data['shop_name'].toString()
                                  : 'Add your shop information',
                              color: darkGrey,
                            ),
                            trailing: const Icon(Icons.chevron_right),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            onTap: () => Get.to(() => const MessagesScreen()),
                            leading: const Icon(
                              Icons.chat_bubble_outline,
                              color: purpleColor,
                            ),
                            title: boldText(text: messages, color: fontGrey),
                            subtitle: normalText(
                              text: 'Talk with customers',
                              color: darkGrey,
                            ),
                            trailing: const Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class _ProfileImage extends StatelessWidget {
  const _ProfileImage({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return const CircleAvatar(radius: 30, child: Icon(Icons.store));
    }
    return ClipOval(
      child: Image.network(
        url,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const CircleAvatar(radius: 30, child: Icon(Icons.store)),
      ),
    );
  }
}

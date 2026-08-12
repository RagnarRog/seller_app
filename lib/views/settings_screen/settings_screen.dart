import 'package:get/get.dart';
import 'package:seller_app/const/const.dart';
import 'package:seller_app/views/messages_screen/messages_screen.dart';
import 'package:seller_app/views/shop_screen/shop_settings.dart';
import 'package:seller_app/views/widgets/normal_text.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: boldText(text: settings, color: fontGrey, size: 18.0),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            onTap: () => Get.to(() => const ShopSettings()),
            leading: const Icon(Icons.storefront_outlined, color: purpleColor),
            title: boldText(text: shopSettings, color: fontGrey),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () => Get.to(() => const MessagesScreen()),
            leading: const Icon(Icons.chat_bubble_outline, color: purpleColor),
            title: boldText(text: messages, color: fontGrey),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

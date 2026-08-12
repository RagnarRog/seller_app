import 'package:get/get.dart';
import 'package:seller_app/controllers/home_controller.dart';
import 'package:seller_app/views/home_screen/home_screen.dart';
import 'package:seller_app/views/order_screen/order_screen.dart';
import 'package:seller_app/views/products_screen/products_screen.dart';
import 'package:seller_app/views/profile_screen/profile_screen.dart';

import '../../const/const.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    var navScreens = [
      const HomeScreen(),
      const ProductsScreen(),
      const OrderScreen(),
      const ProfileScreen(),
    ];
    var bottomNavbar = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: dashboard,
      ), // BottomNavigationBarItem
      BottomNavigationBarItem(
        icon: Image.asset(icProducts, color: darkGrey, width: 24),
        label: products,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icOrders, width: 24, color: darkGrey),
        label: orders,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icGeneralSettings, width: 24, color: darkGrey),
        label: settings,
      ),
    ];

    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: (index) {
            controller.navIndex.value = index;
          },
          backgroundColor: white,
          elevation: 12,
          currentIndex: controller.navIndex.value,
          type: BottomNavigationBarType.fixed,
          items: bottomNavbar,
          selectedItemColor: purpleColor,
          unselectedItemColor: darkGrey,
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(child: navScreens.elementAt(controller.navIndex.value)),
          ],
        ),
      ),
    ); // Scaffold
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:get/get.dart';
import 'package:seller_app/const/const.dart';
import 'package:seller_app/views/auth_screen/login_screen.dart';
import 'package:seller_app/firebase_options.dart';

import 'const/firebase_consts.dart';
import 'views/home_screen/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var isLoggedin = false;

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  Future<void> checkUser() async {
    auth.authStateChanges().listen((User? user) {
      if (!mounted) return;
      isLoggedin = user != null;
      setState(() {});
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      home: isLoggedin ? const Home() : const LoginScreen(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: purpleColor),
        scaffoldBackgroundColor: lightGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: white,
          surfaceTintColor: white,
          elevation: 0,
        ),
      ),
    );
  }
}

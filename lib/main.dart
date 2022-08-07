import 'package:bet/global/storage.dart';
import 'package:bet/middleware/precache_files_bet_middleware.dart';
import 'package:bet/view/bet_page.dart';
import 'package:bet/view/cashier_page.dart';
import 'package:bet/view/email_verified.dart';
import 'package:bet/view/help_page.dart';
import 'package:bet/view/home_page.dart';
import 'package:bet/view/login_signup_page.dart';
import 'package:bet/view/profile_page.dart';
import 'package:bet/view/reset_password_page.dart';
import 'package:bet/view/swap_page.dart';
import 'package:bet/view/term_of_service_page.dart';
import 'package:bet/view/unknown_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_strategy/url_strategy.dart';

import 'middleware/precache_files_home_middleware.dart';
import 'middleware/token_check_middleware.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    checkToken();
  }

  void checkToken() async {
    Storage.isTokenSaved.value = await isContainKey('token');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GetMaterialApp(
      title: "BullRun",
      builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget!),
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(450, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800,
                name: TABLET, scaleFactor: 0.9),
            const ResponsiveBreakpoint.autoScale(1000,
                name: TABLET, scaleFactor: 0.9),
            const ResponsiveBreakpoint.autoScale(1200,
                name: DESKTOP, scaleFactor: 0.9),
            const ResponsiveBreakpoint.autoScale(2460,
                name: "4K", scaleFactor: 1.5),
          ],
          background: Container(color: const Color(0xff214F37))),
      debugShowCheckedModeBanner: false,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
      },
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xff6527f8),
          fontFamily: 'gilroy',
          progressIndicatorTheme:
              const ProgressIndicatorThemeData(color: Colors.white),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  backgroundColor: Colors.transparent))),
      defaultTransition: Transition.zoom,
      initialRoute: '/home',
      unknownRoute: GetPage(
        name: '/unknown',
        page: () => const UnknownRoutePage(),
      ),
      getPages: [
        GetPage(
            name: '/home',
            title: "Home",
            page: () => const HomePage(),
            middlewares: [
              PrecacheFilesHomeMiddleware(),
              PrecacheFilesBetMiddleware()
            ]),
        GetPage(
          name: '/bet',
          title: "Bet",
          page: () => const BetPage(),
          // middlewares: []
        ),
        GetPage(
            title: "Swap",
            name: '/swap',
            page: () => SwapPage(),
            middlewares: [TokenCheckMiddleware()]),
        GetPage(
            title: "Profile",
            name: '/profile',
            page: () => ProfilePage(),
            middlewares: [TokenCheckMiddleware()]),
        GetPage(name: '/term', page: () => const TermOfServicePage()),
        GetPage(name: '/help', page: () => const HelpPage()),
        GetPage(
            title: "Cashier",
            name: '/cashier',
            page: () => CashierPage(),
            middlewares: [TokenCheckMiddleware()]),
        GetPage(
          title: "Login Signup",
          name: '/login-signup',
          page: () => LoginSignUpPage(),
        ),
        GetPage(name: '/auth/resetPassword', page: () => ResetPasswordPage()),
        GetPage(name: '/auth/emailVerified', page: () => const EmailVerified()),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

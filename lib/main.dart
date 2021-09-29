import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'initial_page.dart';
import 'provider/email_sign_in_provider.dart';
import 'provider/google_sign_in_provider.dart';
import 'provider/product_provider.dart';
import 'screens/auth_screen/auth_page.dart';
import 'screens/product_screen/edit_product_screen.dart';
import 'screens/product_screen/product_screen.dart';
import 'utility/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await EmployeeSalaryReportApi.init();
  // await UserSimplePreferences.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (ctx) => EmailSignInProvider()),
        ChangeNotifierProvider(create: (ctx) => ProductProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: kBgColor,
          appBarTheme: const AppBarTheme(backgroundColor: kCyanColor),
          fontFamily: 'Metropolis_Regular',
        ),
        title: kApptitle,
        initialRoute: '/',
        routes: {
          '/': (ctx) => const InitialPage(),
          '/authPage': (ctx) => const AuthPage(),
          '/ProductScreen': (ctx) => const ProductScreen(),
          '/EditProductScreen': (ctx) => const EditProductScreen(),
        },
      ),
    );
  }
}

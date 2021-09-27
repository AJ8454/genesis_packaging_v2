import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'initial_page.dart';
import 'provider/google_sign_in_provider.dart';
import 'screens/auth_screen/auth_page.dart';
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
  static const String title = 'Genesis Packaging';

  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => GoogleSignInProvider()),
      ],
      child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.pink,
              scaffoldBackgroundColor: kBgColor,
              //fontFamily: 'DMSans',
            ),
            title: title,
            initialRoute: '/',
            routes: {
              '/': (ctx) => const InitialPage(),
              '/authPage': (ctx) => const AuthPage(),
            },
          ),
       
    );
  }
}
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'initial_page.dart';
import 'provider/customer_provider.dart';
import 'provider/email_sign_in_provider.dart';
import 'provider/employee_provider.dart';
import 'provider/google_sign_in_provider.dart';
import 'provider/product_provider.dart';
import 'provider/purchase_entry_provider.dart';
import 'provider/vendor_provider.dart';
import 'screens/auth_screen/auth_page.dart';
import 'screens/customer_detail_screen/customer_detail_screen.dart';
import 'screens/customer_detail_screen/edit_customer_screen.dart';
import 'screens/employees_screen/edit_employee_screen.dart';
import 'screens/employees_screen/employee_screen.dart';
import 'screens/orders_screen/order_screen.dart';
import 'screens/product_screen/edit_product_screen.dart';
import 'screens/product_screen/product_screen.dart';
import 'screens/purchase_entry_screen/purchase_entry_screen.dart';
import 'screens/vendor_detail_screen/edit_vendor_screen.dart';
import 'screens/vendor_detail_screen/vendor_detail_screen.dart';
import 'utility/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        ChangeNotifierProvider(create: (ctx) => EmployeeProvider()),
        ChangeNotifierProvider(create: (ctx) => VendorProvider()),
        ChangeNotifierProvider(create: (ctx) => CustomerProvider()),
        ChangeNotifierProvider(create: (ctx) => PurchaseEntryProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          appBarTheme: const AppBarTheme(backgroundColor: kCyanColor),
          fontFamily: 'OnePlus-Regular',
        ),
        title: kApptitle,
        initialRoute: '/',
        routes: {
          '/': (ctx) => const InitialPage(),
          '/authPage': (ctx) => const AuthPage(),
          '/ProductScreen': (ctx) => const ProductScreen(),
          '/EditProductScreen': (ctx) => const EditProductScreen(),
          '/EmployeeScreen': (ctx) => const EmployeeScreen(),
          '/EditEmployeeScreen': (ctx) => const EditEmployeeScreen(),
          '/OrderScreen': (ctx) => const OrderScreen(),
          '/VendorDetailScreen': (ctx) => const VendorDetailScreen(),
          '/EditVendorScreen': (ctx) => const EditVendorScreen(),
          '/CustomerDetailScreen': (ctx) => const CustomerDetailScreen(),
          '/EditCustomerScreen': (ctx) => const EditCustomerScreen(),
          '/PurchaseEntryScreen': (ctx) => const PurchaseEntryScreen(),
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'providers/app_state.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/location_selection_screen.dart';
import 'screens/home_screen.dart';
import 'screens/menu_customization_sheet.dart';
import 'screens/cart_screen.dart';
import 'screens/order_tracking_screen.dart';
import 'screens/review_screen.dart';
import 'screens/staff_dashboard_screen.dart';
import 'screens/qr_scanner_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: MaterialApp(
        title: 'CafeClick',
        theme: AppTheme.darkTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/register': (context) => const RegistrationScreen(),
          '/location': (context) => const LocationSelectionScreen(),
          '/home': (context) => const HomeScreen(),
          '/menu-customization': (context) => const MenuCustomizationSheet(),
          '/cart': (context) => const CartScreen(),
          '/order-tracking': (context) => const OrderTrackingScreen(),
          '/review': (context) => const ReviewScreen(),
          '/staff-dashboard': (context) => const StaffDashboardScreen(),
          '/qr-scanner': (context) => const QRScannerScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../features/comman/splash/presentation/pages/splash_page.dart';
import '../../features/comman/auth/presentation/pages/login_page.dart';
import '../../features/comman/auth/presentation/pages/register_page.dart';
import '../../features/farmer/home/presentation/pages/home_page.dart';
import '../../features/farmer/product/presentation/pages/add_product_page.dart';
import '../../features/farmer/product/presentation/pages/my_products_page.dart';
import '../../features/buyer/product/presentation/pages/buyer_product_details_page.dart';
import '../../features/buyer/product/presentation/pages/buyer_place_request_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String login  = '/login';
  static const String register = '/register';
  static const String home   = '/home';
  static const String addProduct = '/addProduct';
  static const String myProducts = '/myProducts';
  static const String buyerProductDetails = '/buyerProductDetails';
  static const String buyerPlaceRequest = '/buyerPlaceRequest';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case home:
        final bool isBuyer = settings.arguments as bool? ?? false;
        return MaterialPageRoute(builder: (_) => HomePage(isBuyer: isBuyer));
      case addProduct:
        return MaterialPageRoute(builder: (_) => const AddProductPage());
      case myProducts:
        return MaterialPageRoute(builder: (_) => const MyProductsPage());
      case buyerProductDetails:
        return MaterialPageRoute(builder: (_) => const BuyerProductDetailsPage());
      case buyerPlaceRequest:
        return MaterialPageRoute(builder: (_) => const BuyerPlaceRequestPage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}

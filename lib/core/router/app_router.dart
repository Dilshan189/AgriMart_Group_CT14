import 'package:flutter/material.dart';
import '../../features/comman/splash/presentation/pages/wellcome_page.dart';
import '../../features/comman/auth/presentation/pages/login_page.dart';
import '../../features/comman/auth/presentation/pages/register_page.dart';
import '../../features/farmer/home/presentation/pages/home_page.dart';
import '../../features/farmer/product/presentation/pages/add_product_page.dart';
import '../../features/farmer/product/presentation/pages/my_products_page.dart';
import '../../features/buyer/product/presentation/pages/buyer_product_details_page.dart';
import '../../features/buyer/product/presentation/pages/buyer_place_request_page.dart';
import '../../features/buyer/requests/presentation/pages/buyer_post_open_request_page.dart';

import '../models/product_model.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String addProduct = '/addProduct';
  static const String myProducts = '/myProducts';
  static const String buyerProductDetails = '/buyerProductDetails';
  static const String buyerPlaceRequest = '/buyerPlaceRequest';
  static const String buyerPostOpenRequest = '/buyerPostOpenRequest';

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) =>
          const Scaffold(body: Center(child: Text('Page not found'))),
    );
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case home:
        String role = 'farmer';
        if (settings.arguments is bool) {
          role = (settings.arguments as bool) ? 'buyer' : 'farmer';
        } else if (settings.arguments is String) {
          role = settings.arguments as String;
        }
        return MaterialPageRoute(builder: (_) => HomePage(userRole: role));
      case addProduct:
        final productToEdit = settings.arguments as ProductModel?;
        return MaterialPageRoute(builder: (_) => AddProductPage(productToEdit: productToEdit));
      case myProducts:
        return MaterialPageRoute(builder: (_) => const MyProductsPage());
      case buyerProductDetails:
        if (settings.arguments is ProductModel) {
          return MaterialPageRoute(
            builder: (_) => BuyerProductDetailsPage(product: settings.arguments as ProductModel),
          );
        }
        return _errorRoute();
      case buyerPlaceRequest:
        if (settings.arguments is ProductModel) {
          return MaterialPageRoute(
            builder: (_) => BuyerPlaceRequestPage(product: settings.arguments as ProductModel),
          );
        }
        return _errorRoute();
      case buyerPostOpenRequest:
        return MaterialPageRoute(builder: (_) => const BuyerPostOpenRequestPage());
      default:
        return _errorRoute();
    }
  }
}

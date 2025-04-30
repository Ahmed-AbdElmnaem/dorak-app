import 'package:dorak_app/core/routing/routes.dart';
import 'package:dorak_app/features/auth/login/ui/screen/login_screen.dart';
import 'package:dorak_app/features/auth/login/ui/screen/register_screen.dart';
import 'package:dorak_app/features/group_details/data/group_details_args.dart';
import 'package:dorak_app/features/group_details/ui/screens/group_details_screen.dart';
import 'package:dorak_app/features/home/ui/screens/home_screen.dart';
import 'package:dorak_app/features/intro/splash/ui/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case Routes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());

      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case Routes.groupDetails:
        if (args is GroupDetailsArgs) {
          return MaterialPageRoute(
            builder:
                (_) => GroupDetailsScreen(
                  userId: args.userId,
                  group: args.group,
                  paymentDates: args.paymentDates,
                ),
          );
        }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  // A method to handle unknown routes and return an error page.
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: const Text("Error")),
            body: const Center(child: Text("Route not found")),
          ),
    );
  }
}

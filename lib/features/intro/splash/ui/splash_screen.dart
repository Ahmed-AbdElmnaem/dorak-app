import 'package:animate_do/animate_do.dart';
import 'package:dorak_app/core/helpers/extension.dart';
import 'package:dorak_app/core/routing/routes.dart';
import 'package:dorak_app/core/theming/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    navigateAfter3Sec(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.mainColor,
      body: Center(
        child: FadeInUp(child: Image.asset("assets/images/logo.png")),
      ),
    );
  }

  navigateAfter3Sec(BuildContext context) async {
    Future.delayed(const Duration(seconds: 4), () async {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId != null) {
        final isAuthenticated = await _authenticateWithBiometrics();
        if (isAuthenticated) {
          if (context.mounted) {
            context.pushNamedAndRemoveUntil(
              Routes.home,
              predicate: (route) => false,
            );
          }
        } else {
          if (context.mounted) {
            context.pushNamedAndRemoveUntil(
              Routes.login,
              predicate: (route) => false,
            );
          }
        }
      } else {
        if (context.mounted) {
          context.pushNamedAndRemoveUntil(
            Routes.login,
            predicate: (route) => false,
          );
        }
      }
    });
  }

  Future<bool> _authenticateWithBiometrics() async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (canCheckBiometrics) {
        final isAuthenticated = await _localAuth.authenticate(
          localizedReason: 'من فضلك تحقق باستخدام بصمتك للوصول للتطبيق',
          options: const AuthenticationOptions(biometricOnly: true),
        );
        return isAuthenticated;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

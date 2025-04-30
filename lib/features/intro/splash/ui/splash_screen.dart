import 'package:animate_do/animate_do.dart';
import 'package:dorak_app/core/helpers/extension.dart';
import 'package:dorak_app/core/routing/routes.dart';
import 'package:dorak_app/core/theming/color_manager.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigateAfter3Sec(context);

    super.initState();
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

  navigateAfter3Sec(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        context.pushNamedAndRemoveUntil(
          Routes.login,
          predicate: (route) => false,
        );
      }
    });
  }
}

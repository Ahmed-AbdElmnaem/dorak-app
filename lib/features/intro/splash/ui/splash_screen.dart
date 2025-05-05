import 'package:animate_do/animate_do.dart';
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
    // التأكد من التنقل بعد اكتمال بناء الشجرة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () async {
        navigateAfter3Sec(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.mainColor,
      body: Center(
        child: FadeInUp(
          duration: const Duration(seconds: 2),
          child: Image.asset("assets/images/logo.png"),
        ),
      ),
    );
  }

  // تنفيذ المنطق بعد تأخير 3 ثواني
  Future<void> navigateAfter3Sec(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    // التأكد من أن الـ State مازالت موجودة قبل التنقل
    if (!mounted) return;

    if (userId == null) {
      Navigator.pushReplacementNamed(context, Routes.login);
      return;
    }

    final canCheckBiometrics = await _localAuth.canCheckBiometrics;
    if (!canCheckBiometrics) {
      _showBiometricFailedBottomSheet(context);
      return;
    }

    final isAuthenticated = await _authenticateWithBiometrics();
    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, Routes.home);
    } else {
      _showBiometricFailedBottomSheet(context);
    }
  }

  Future<bool> _authenticateWithBiometrics() async {
    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'من فضلك تحقق باستخدام بصمتك للوصول للتطبيق',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true, // للحفاظ على شاشة البصمة مفتوحة في بعض الأجهزة
        ),
      );
      return isAuthenticated;
    } catch (_) {
      return false;
    }
  }

  // إعادة المحاولة في حالة فشل التحقق بالبصمة
  void retryBiometricAuth(BuildContext context) async {
    final isAuthenticated = await _authenticateWithBiometrics();
    if (isAuthenticated) {
      if (mounted) {
        Navigator.pop(context); // غلق البوتوم شيت
        Navigator.pushReplacementNamed(context, Routes.home);
      }
    }
  }

  // عرض البوتوم شيت إذا فشل التحقق بالبصمة
  void _showBiometricFailedBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'لم يتم التحقق بالبصمة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'فشلت محاولة التحقق. يمكنك المحاولة مرة أخرى أو تسجيل الدخول يدويًا.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  retryBiometricAuth(context);
                },
                icon: const Icon(Icons.fingerprint),
                label: const Text('المحاولة مرة أخرى'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // غلق البوتوم شيت
                  Navigator.pushReplacementNamed(context, Routes.login);
                },
                child: const Text('تسجيل الدخول يدويًا'),
              ),
            ],
          ),
        );
      },
    );
  }

  // وظيفة لعرض حوار فشل التحقق بالبصمة
  void _showAuthenticationFailedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('فشل التحقق بالبصمة'),
          content: const Text(
            'فشل التحقق باستخدام بصمتك. الرجاء المحاولة مرة أخرى أو تسجيل الدخول باستخدام بياناتك.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('تسجيل الدخول'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, Routes.login);
              },
            ),
          ],
        );
      },
    );
  }
}

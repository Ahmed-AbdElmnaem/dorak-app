import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintAuthHelper {
  static Future<bool> authenticate(BuildContext context) async {
    final auth = LocalAuthentication();

    try {
      bool canAuthenticate = await auth.canCheckBiometrics;
      bool isSupported = await auth.isDeviceSupported();
      if (!canAuthenticate || !isSupported) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('جهازك لا يدعم خاصية البصمة.'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }

      return await auth.authenticate(
        localizedReason: 'من فضلك قم بتأكيد البصمة لحفظ البيانات',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء التحقق بالبصمة.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }
}

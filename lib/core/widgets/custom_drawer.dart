import 'package:dorak_app/core/routing/routes.dart';
import 'package:dorak_app/core/theming/color_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? ''),
            accountEmail: Text(user?.email ?? 'user@example.com'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: ColorManager.mainColor,
                size: 30,
              ),
            ),
            decoration: const BoxDecoration(color: ColorManager.mainColor),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: ColorManager.mainColor),
            title: const Text('الصفحة الرئيسية'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(
              Icons.info_outline,
              color: ColorManager.mainColor,
            ),
            title: const Text('عن التطبيق'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.about);
            },
          ),
          const Divider(thickness: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('تأكيد تسجيل الخروج'),
            content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
            actions: [
              TextButton(
                child: const Text('إلغاء'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('تسجيل الخروج'),
                onPressed: () async {
                  Navigator.pop(context); // يغلق الـ AlertDialog
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.login,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
    );
  }
}

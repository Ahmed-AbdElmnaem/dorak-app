// lib/features/about/ui/about_screen.dart
import 'package:dorak_app/core/theming/color_manager.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عن التطبيق'),
        centerTitle: true,
        backgroundColor: ColorManager.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset('assets/images/logo.png', height: 120)),
            const SizedBox(height: 20),
            const Text(
              'تطبيق دورك - Dorak',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'تطبيق "دورك" هو أداة ذكية لإدارة الجمعيات المالية بين الأصدقاء أو العائلة. يساعدك في تنظيم الأدوار، متابعة المدفوعات، معرفة تاريخ استحقاق كل فرد، والحفاظ على كل البيانات بأمان وسهولة.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'الميزات:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            BulletPoint(text: 'إضافة مجموعات جمعيات بعدد أيام وأعضاء محددين'),
            BulletPoint(text: 'توليد جدول تلقائي للدفع حسب الترتيب'),
            BulletPoint(text: 'تتبع حالة الدفع لكل عضو في كل دور'),
            BulletPoint(text: 'مصادقة ببصمة لضمان الأمان'),
            BulletPoint(text: 'واجهة سهلة ومبسطة'),
            const Spacer(),
            const Center(child: Text('الإصدار 1.0.0')),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

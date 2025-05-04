import 'package:flutter/material.dart';

import '../../../../core/theming/styles.dart';

void showAddMemberDialog({
  required BuildContext context,
  required int maxMembers,
  required int currentMembersCount,
  required Function(String) onAdd,
}) {
  final nameController = TextEditingController();

  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: const Text("ضافة عضو جديد بناءً على ترتيب الأولوية"),
          titleTextStyle: Styles.font21W700.copyWith(color: Colors.black),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "اسم العضو",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("إلغاء"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("إضافة"),
              onPressed: () {
                final name = nameController.text.trim();

                if (currentMembersCount >= maxMembers) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم الوصول للحد الأقصى من الأعضاء'),
                    ),
                  );
                  Navigator.pop(context);
                  return;
                }

                if (name.isNotEmpty) {
                  onAdd(name);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
  );
}

import 'package:dorak_app/core/widgets/app_text_form_field.dart';
import 'package:flutter/material.dart';

class MemberRow {
  static DataRow build({
    required int index,
    required TextEditingController nameController,
    required List<bool> payments,
    required void Function(int paymentIndex, bool value) onPaymentChanged,
    required void Function(String newName)
    onNameChanged, // إضافة الـ callback هنا
  }) {
    return DataRow(
      cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(
          AppTextFormField(
            controller: nameController,
            hintText: 'اسم العضو',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الاسم مطلوب';
              }
              return null;
            },
            onChanged: (newName) {
              onNameChanged(newName); // استدعاء الـ callback عند التغيير
            },
          ),
        ),
        ...List.generate(
          payments.length,
          (paymentIndex) => DataCell(
            Checkbox(
              value: payments[paymentIndex] == true, // ✅ تأكيد عدم وجود null
              onChanged: (value) {
                onPaymentChanged(paymentIndex, value ?? false);
              },
            ),
          ),
        ),
      ],
    );
  }
}

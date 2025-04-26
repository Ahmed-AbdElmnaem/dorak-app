import 'package:flutter/material.dart';

class MemberRow {
  static DataRow build({
    required int index,
    required TextEditingController nameController,
    required List<bool> payments,
    required Function(int paymentIndex, bool value) onPaymentChanged,
  }) {
    return DataRow(
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'أدخل الاسم',
              border: InputBorder.none,
            ),
          ),
        ),
        ...List.generate(payments.length, (paymentIndex) {
          return DataCell(
            Checkbox(
              value: payments[paymentIndex],
              onChanged: (value) {
                onPaymentChanged(paymentIndex, value!);
              },
            ),
          );
        }),
      ],
    );
  }
}

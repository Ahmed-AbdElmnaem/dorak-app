import 'package:flutter/material.dart';

class MemberRow {
  static DataRow build({
    required int index,
    required TextEditingController nameController,
    required List<bool> payments,
    required void Function(int paymentIndex, bool value) onPaymentChanged,
  }) {
    return DataRow(
      cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(
          TextField(
            controller: nameController,
            decoration: const InputDecoration(border: InputBorder.none),
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

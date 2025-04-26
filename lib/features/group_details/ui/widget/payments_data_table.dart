import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'member_row.dart';

class PaymentsDataTable extends StatelessWidget {
  final List<DateTime> paymentDates;
  final List<List<bool>> payments;
  final List<TextEditingController> nameControllers;
  final void Function(int memberIndex, int paymentIndex, bool value)
  onPaymentChanged;

  const PaymentsDataTable({
    super.key,
    required this.paymentDates,
    required this.payments,
    required this.nameControllers,
    required this.onPaymentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        headingRowColor: WidgetStateColor.resolveWith(
          (states) => Colors.grey[200]!,
        ),
        border: TableBorder.all(color: Colors.grey.shade300),
        columns: [
          const DataColumn(label: Text('#')),
          const DataColumn(label: Text('الاسم')),
          ...paymentDates.map(
            (date) => DataColumn(
              label: Column(
                children: [
                  Text('الدور ${paymentDates.indexOf(date) + 1}'),
                  Text(
                    DateFormat('dd/MM').format(date),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
        rows: List.generate(
          nameControllers.length,
          (index) => MemberRow.build(
            index: index,
            nameController: nameControllers[index],
            payments: payments[index],
            onPaymentChanged:
                (paymentIndex, value) =>
                    onPaymentChanged(index, paymentIndex, value),
          ),
        ),
      ),
    );
  }
}

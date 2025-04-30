import 'package:dorak_app/features/group_details/logic/cubit/group_details_cubit.dart';
import 'package:dorak_app/features/group_details/ui/widget/member_row.dart';
import 'package:dorak_app/features/home/data/model/group_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentsDataTable extends StatefulWidget {
  final List<MemberModel> members; // ✅
  final GroupModel group;
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
    required this.group,
    required this.members, // ✅
  });

  @override
  _PaymentsDataTableState createState() => _PaymentsDataTableState();
}

class _PaymentsDataTableState extends State<PaymentsDataTable> {
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
          ...widget.paymentDates.map(
            (date) => DataColumn(
              label: Column(
                children: [
                  Text('الدور ${widget.paymentDates.indexOf(date) + 1}'),
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
          widget.nameControllers.length,
          (index) => MemberRow.build(
            index: index,
            nameController: widget.nameControllers[index],
            payments: widget.payments[index],
            onPaymentChanged: (paymentIndex, value) {
              widget.onPaymentChanged(index, paymentIndex, value);

              BlocProvider.of<GroupDetailsCubit>(context).updatePaymentStatus(
                userId: FirebaseAuth.instance.currentUser?.uid ?? '',
                groupId: widget.group.id.toString(),
                memberId: widget.members[index].id.toString(), // ✅ صح كده
                paymentIndex:
                    widget.paymentDates[paymentIndex].toIso8601String(),
                value: value,
              );
            },
          ),
        ),
      ),
    );
  }
}

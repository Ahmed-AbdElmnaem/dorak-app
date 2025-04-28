import 'package:dorak_app/core/helpers/fingerprint_auth_helper.dart';
import 'package:dorak_app/features/group_details/ui/widget/group_info_card.dart';
import 'package:dorak_app/features/group_details/ui/widget/payments_data_table.dart';
import 'package:dorak_app/features/group_details/ui/widget/save_button.dart';
import 'package:dorak_app/features/home/data/model/group_model.dart';
import 'package:flutter/material.dart';

class GroupDetailsScreen extends StatefulWidget {
  final List<DateTime> paymentDates;
  final GroupModel group;

  const GroupDetailsScreen({
    super.key,
    required this.paymentDates,
    required this.group,
  });

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  late List<List<bool>> payments;
  late List<TextEditingController> nameControllers;

  @override
  void initState() {
    super.initState();
    payments = List.generate(
      widget.group.membersCount,
      (_) => List.generate(widget.paymentDates.length, (_) => false),
    );
    nameControllers = List.generate(
      widget.group.membersCount,
      (_) => TextEditingController(),
    );
  }

  Future<void> _handleSave() async {
    final isAuthenticated = await FingerprintAuthHelper.authenticate(context);
    if (!isAuthenticated) return;

    for (var controller in nameControllers) {
      if (controller.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('من فضلك أدخل اسم لكل عضو قبل الحفظ'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    List<Map<String, dynamic>> membersData = List.generate(
      widget.group.membersCount,
      (index) {
        return {
          'name': nameControllers[index].text.trim(),
          'payments': payments[index],
        };
      },
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ البيانات بنجاح'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تفاصيل المجموعة: ${widget.group.name}')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GroupInfoCard(group: widget.group),
            PaymentsDataTable(
              paymentDates: widget.paymentDates,
              payments: payments,
              nameControllers: nameControllers,
              onPaymentChanged: (memberIndex, paymentIndex, value) {
                setState(() {
                  payments[memberIndex][paymentIndex] = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 20.0,
              ),
              child: SaveButton(onPressed: _handleSave),
            ),
          ],
        ),
      ),
    );
  }
}

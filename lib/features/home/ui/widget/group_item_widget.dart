import 'package:animate_do/animate_do.dart';
import 'package:dorak_app/core/theming/color_manager.dart';
import 'package:dorak_app/core/theming/styles.dart';
import 'package:dorak_app/features/home/data/model/group_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // إضافة import هنا
import 'package:intl/intl.dart';

class GroupItemWidget extends StatelessWidget {
  final GroupModel group;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const GroupItemWidget({
    super.key,
    required this.group,
    required this.index,
    required this.onTap,
    required this.onDelete,
  });

  Future<void> _confirmDeleteGroup(BuildContext context) async {
    final bool shouldDelete =
        await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('تأكيد الحذف'),
              content: const Text('هل أنت متأكد أنك تريد حذف هذه الجمعية؟'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('إلغاء'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('حذف'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (shouldDelete) {
      onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      duration: Duration(milliseconds: 700 + index * 100),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
        child: Slidable(
          dragStartBehavior: DragStartBehavior.down,
          startActionPane: ActionPane(
            closeThreshold: 0.1,
            dragDismissible: false,
            extentRatio: 0.25,
            motion: DrawerMotion(),
            dismissible: DismissiblePane(
              onDismissed: () {
                _confirmDeleteGroup(context);
              },
            ),
            children: [
              SlidableAction(
                flex: 1,
                autoClose: true,
                borderRadius: BorderRadius.circular(15.0),
                onPressed:
                    (context) =>
                        _confirmDeleteGroup(context), // تنفيذ الحذف بعد التأكيد
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'حذف',
              ),
            ],
          ),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: ColorManager.mainColor,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildInfoRow(
                    Icons.date_range,
                    'من ${DateFormat('dd/MM').format(group.startDate)} الى ${DateFormat('dd/MM').format(group.endDate)}',
                  ),
                  SizedBox(height: 6.0),
                  buildInfoRow(Icons.person, 'الاسم: ${group.name}'),
                  SizedBox(height: 6.0),
                  buildInfoRow(
                    Icons.monetization_on,
                    'المبلغ اليومي: ${group.dailyAmount}ج',
                  ),
                  SizedBox(height: 6.0),
                  buildInfoRow(
                    Icons.account_balance_wallet,
                    'المبلغ الإجمالي: ${group.dailyAmount * group.cycleDays}ج',
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.group, color: Colors.white),
                      SizedBox(width: 8.0),
                      Text('${group.membersCount}', style: Styles.font15W500),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white),
        SizedBox(width: 6.0),
        Text(text, style: Styles.font15W500),
      ],
    );
  }
}

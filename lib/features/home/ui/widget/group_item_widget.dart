import 'package:animate_do/animate_do.dart';
import 'package:dorak_app/core/theming/color_manager.dart';
import 'package:dorak_app/core/theming/styles.dart';
import 'package:dorak_app/features/home/data/model/group_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupItemWidget extends StatelessWidget {
  final GroupModel group;
  final int index;
  final VoidCallback onTap;

  const GroupItemWidget({
    super.key,
    required this.group,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      duration: Duration(milliseconds: 700 + index * 200),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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

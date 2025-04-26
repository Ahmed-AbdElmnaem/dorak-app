import 'package:dorak_app/features/home/data/model/group_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupInfoCard extends StatelessWidget {
  final GroupModel group;

  const GroupInfoCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final totalDailyAmount = group.dailyAmount * group.membersCount;
    final totalCycleAmount = totalDailyAmount * group.cycleDays;

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: const Text(
          "تفاصيل الجمعية",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildRowInfo("اسم الجمعية", group.name),
                _buildRowInfo("عدد الأعضاء", group.membersCount.toString()),
                _buildRowInfo("المبلغ اليومي", "${group.dailyAmount} جنيه"),
                _buildRowInfo("مدة كل دور", "${group.cycleDays} يوم"),
                _buildRowInfo(
                  "تاريخ البداية",
                  DateFormat('yyyy-MM-dd').format(group.startDate),
                ),
                _buildRowInfo(
                  "تاريخ النهاية",
                  DateFormat('yyyy-MM-dd').format(group.endDate),
                ),
                const Divider(),
                _buildRowInfo(
                  "إجمالي المبلغ اليومي",
                  "${totalDailyAmount.toStringAsFixed(2)} جنيه",
                ),
                _buildRowInfo(
                  "إجمالي مبلغ كل دور",
                  "${totalCycleAmount.toStringAsFixed(2)} جنيه",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

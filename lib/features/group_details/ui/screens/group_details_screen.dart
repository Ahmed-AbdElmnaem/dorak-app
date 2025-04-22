import 'package:animate_do/animate_do.dart';
import 'package:dorak_app/features/home/data/model/group_Model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  final TextStyle _infoStyle = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  String _getArabicOrder(int number) {
    return 'الدور $number';
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تفاصيل المجموعة: ${widget.group.name}')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildGroupInfo(),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FadeInRight(
                duration: const Duration(milliseconds: 500),
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor: WidgetStateColor.resolveWith(
                    (states) => Colors.grey[200]!,
                  ),
                  border: TableBorder.all(color: Colors.grey.shade300),
                  columns: [
                    const DataColumn(label: Text('#')),
                    const DataColumn(label: Text('الاسم')),
                    ...List.generate(widget.paymentDates.length, (index) {
                      return DataColumn(
                        label: Column(
                          children: [
                            Text(_getArabicOrder(index + 1)),
                            Text(
                              DateFormat(
                                'dd/MM',
                              ).format(widget.paymentDates[index]),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                  rows: List.generate(widget.group.membersCount, (index) {
                    return DataRow(
                      cells: [
                        DataCell(Text('${index + 1}')),
                        DataCell(
                          TextField(
                            controller: nameControllers[index],
                            decoration: const InputDecoration(
                              hintText: 'أدخل الاسم',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        ...List.generate(widget.paymentDates.length, (
                          paymentIndex,
                        ) {
                          return DataCell(
                            Checkbox(
                              value: payments[index][paymentIndex],
                              onChanged: (value) {
                                setState(() {
                                  payments[index][paymentIndex] = value!;
                                });
                              },
                            ),
                          );
                        }),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupInfo() {
    final totalAmount = widget.group.dailyAmount * widget.group.membersCount;

    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row with multiple information displayed side by side
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoColumn("اسم الجمعية", widget.group.name),
                    _buildInfoColumn(
                      "عدد الأعضاء",
                      "${widget.group.membersCount}",
                    ),
                    _buildInfoColumn(
                      "المبلغ اليومي",
                      "${widget.group.dailyAmount} جنيه",
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoColumn(
                      "مدة كل دور",
                      "${widget.group.cycleDays} يوم",
                    ),
                    _buildInfoColumn(
                      "تاريخ البداية",
                      DateFormat('yyyy-MM-dd').format(widget.group.startDate),
                    ),
                    _buildInfoColumn(
                      "تاريخ النهاية",
                      DateFormat('yyyy-MM-dd').format(widget.group.endDate),
                    ),
                  ],
                ),
                const Divider(height: 20),
                // Row for the total amount at the bottom
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoColumn(
                      "إجمالي المبلغ",
                      "${totalAmount.toStringAsFixed(2)} جنيه",
                      isTotal: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value, {bool isTotal = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _infoStyle.copyWith(fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            value,
            style: _infoStyle.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green[700] : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:dorak_app/core/helpers/extension.dart';
import 'package:dorak_app/core/theming/color_manager.dart';
import 'package:dorak_app/features/home/data/model/group_Model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';

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

  void _handleSave() async {
    final LocalAuthentication auth = LocalAuthentication();

    try {
      bool didAuthenticate = await auth.authenticate(
        localizedReason: 'من فضلك قم بتأكيد البصمة لحفظ بيانات الجمعية',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (!didAuthenticate) {
        // لو البصمة فشلت أو المستخدم لغى
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل التحقق بالبصمة. لم يتم حفظ البيانات.'),
            backgroundColor: Colors.red,
          ),
        );
        return; // نوقف الحفظ
      }
    } catch (e) {
      print('Biometric auth error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء التحقق بالبصمة.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ✨ لو البصمة نجحت، نكمل عملية الحفظ ✨
    for (int i = 0; i < nameControllers.length; i++) {
      if (nameControllers[i].text.trim().isEmpty) {
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

    // هنا كمل إرسال البيانات للسيرفر أو تخزينها حسب احتياجك
  }

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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.mainColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'حفظ البيانات',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupInfo() {
    final totalDailyAmount =
        widget.group.dailyAmount *
        widget.group.membersCount; // إجمالي المبلغ اليومي لجميع الأعضاء
    final totalCycleAmount =
        widget.group.dailyAmount *
        widget.group.membersCount *
        widget.group.cycleDays; // إجمالي مبلغ كل دور لجميع الأعضاء

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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoColumn(
                      "إجمالي المبلغ اليومي",
                      "${totalDailyAmount.toStringAsFixed(2)} جنيه", // إجمالي المبلغ اليومي لجميع الأعضاء
                      isTotal: true,
                    ),
                    30.w,
                    _buildInfoColumn(
                      "إجمالي مبلغ كل دور",
                      "${totalCycleAmount.toStringAsFixed(2)} جنيه", // إجمالي المبلغ لكل دور لجميع الأعضاء
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

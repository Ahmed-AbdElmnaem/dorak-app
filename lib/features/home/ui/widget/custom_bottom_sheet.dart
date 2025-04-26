import 'package:dorak_app/core/helpers/extension.dart';
import 'package:dorak_app/core/routing/routes.dart';
import 'package:dorak_app/core/theming/color_manager.dart';
import 'package:dorak_app/core/theming/styles.dart';
import 'package:dorak_app/core/widgets/app_text_form_field.dart';
import 'package:dorak_app/features/group_details/data/group_details_args.dart';
import 'package:dorak_app/features/home/data/model/group_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomBottomSheet extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController membersController;
  final TextEditingController dailyAmountController;
  final TextEditingController cycleDaysController;
  final bool isLoading;
  final Function(GroupModel) onGroupAdded;

  const CustomBottomSheet({
    super.key,
    required this.nameController,
    required this.membersController,
    required this.dailyAmountController,
    required this.cycleDaysController,
    required this.isLoading,
    required this.onGroupAdded,
  });

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  DateTime? startDate;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  disose() {
    widget.nameController.dispose();
    widget.membersController.dispose();
    widget.dailyAmountController.dispose();
    widget.cycleDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "إضافة تفاصيل",
                style: Styles.font17W700,
                textAlign: TextAlign.center,
              ),
              16.0.h,
              _buildTextFormField(
                controller: widget.nameController,
                hintText: "اسم المجموعة",
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: widget.membersController,
                hintText: "عدد الأشخاص",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: widget.dailyAmountController,
                hintText: "المبلغ اليومي",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: widget.cycleDaysController,
                hintText: "فترة كل دورة (بالأيام)",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              _buildDatePicker(context),
              const SizedBox(height: 16),
              widget.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: () => _onAddPressed(context),
                    child: Text("إضافة"),
                  ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
  }) {
    return AppTextFormField(
      controller: controller,
      hintText: hintText,
      keyboardType: keyboardType,
      validator: (v) => v?.isEmpty ?? true ? "هذا الحقل مطلوب" : null,
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: ColorManager.mainColor,
                ),
                onPressed: () async {
                  final picked = await _showDatePicker(context);
                  if (picked != null) {
                    setState(() => startDate = picked);
                  }
                },
                child: Text("اختر تاريخ البداية", style: Styles.font15W500),
              ),
              Text(
                DateFormat('yyyy-MM-dd').format(startDate ?? DateTime.now()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<DateTime?> _showDatePicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorManager.mainColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
  }

  void _onAddPressed(BuildContext context) {
    if (formKey.currentState?.validate() != true || startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى اختيار تاريخ البداية")),
      );
      return;
    }

    final membersCount = int.tryParse(widget.membersController.text) ?? 0;
    final cycleDays = int.tryParse(widget.cycleDaysController.text) ?? 0;

    // حساب تواريخ الدورات
    List<DateTime> paymentDates = [];
    DateTime currentDate = startDate!;
    for (int i = 0; i < membersCount; i++) {
      paymentDates.add(currentDate);
      currentDate = currentDate.add(
        Duration(days: cycleDays),
      ); // إضافة أيام للدورة التالية
    }

    // إنشاء المجموعة
    final group = GroupModel(
      name: widget.nameController.text,
      membersCount: membersCount,
      dailyAmount: double.parse(widget.dailyAmountController.text),
      cycleDays: cycleDays,
      startDate: startDate ?? DateTime.now(),
      endDate: startDate!.add(Duration(days: cycleDays * membersCount)),
    );

    widget.onGroupAdded(group);
    Navigator.pushNamed(
      context,
      Routes.groupDetails,
      arguments: GroupDetailsArgs(group: group, paymentDates: paymentDates),
    );
    widget.nameController.clear();
    widget.membersController.clear();
    widget.dailyAmountController.clear();
    widget.cycleDaysController.clear();
  }
}

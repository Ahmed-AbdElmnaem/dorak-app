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

  @override
  void dispose() {
    widget.nameController.clear();
    widget.membersController.clear();
    widget.dailyAmountController.clear();
    widget.cycleDaysController.clear();
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
            mainAxisSize: MainAxisSize.min,
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
              _buildSubmitButton(context),
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: ColorManager.mainColor,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: _selectStartDate,
            child: Text(
              "اختر تاريخ البداية",
              style: Styles.font15W500.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          startDate != null
              ? DateFormat('yyyy-MM-dd').format(startDate!)
              : "لم يتم اختيار تاريخ",
          style: Styles.font14W400,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child:
          widget.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: () => _validateAndSubmit(context),
                  child: const Text("إضافة"),
                ),
              ),
    );
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
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
            dialogTheme: const DialogTheme(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => startDate = picked);
    }
  }

  void _validateAndSubmit(BuildContext context) {
    if (!_validateForm()) return;

    final group = _createGroupModel();
    widget.onGroupAdded(group);

    _navigateToGroupDetails(context, group);
    _clearForm();
  }

  bool _validateForm() {
    if (formKey.currentState?.validate() != true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("يرجى ملء جميع الحقول")));
      return false;
    }

    if (startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى اختيار تاريخ البداية")),
      );
      return false;
    }

    return true;
  }

  GroupModel _createGroupModel() {
    final membersCount = int.tryParse(widget.membersController.text) ?? 0;
    final cycleDays = int.tryParse(widget.cycleDaysController.text) ?? 0;
    final dailyAmount =
        double.tryParse(widget.dailyAmountController.text) ?? 0.0;

    return GroupModel(
      name: widget.nameController.text,
      membersCount: membersCount,
      dailyAmount: dailyAmount,
      cycleDays: cycleDays,
      startDate: startDate!,
      endDate: startDate!.add(Duration(days: cycleDays * membersCount)),
    );
  }

  void _navigateToGroupDetails(BuildContext context, GroupModel group) {
    final paymentDates = (group.calculatePaymentDates());

    Navigator.pushNamed(
      context,
      Routes.groupDetails,
      arguments: GroupDetailsArgs(group: group, paymentDates: paymentDates),
    );
  }

  void _clearForm() {
    widget.nameController.clear();
    widget.membersController.clear();
    widget.dailyAmountController.clear();
    widget.cycleDaysController.clear();
    setState(() => startDate = null);
  }
}

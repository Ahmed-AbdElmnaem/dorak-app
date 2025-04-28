import 'package:dorak_app/core/routing/routes.dart';
import 'package:dorak_app/core/theming/color_manager.dart';
import 'package:dorak_app/features/group_details/data/group_details_args.dart';
import 'package:dorak_app/features/home/data/model/group_model.dart';
import 'package:dorak_app/features/home/logic/group_cubit.dart';
import 'package:dorak_app/features/home/ui/widget/custom_bottom_sheet.dart';
import 'package:dorak_app/features/home/ui/widget/group_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // مهم جدا

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController membersController = TextEditingController();
  final TextEditingController dailyAmountController = TextEditingController();
  final TextEditingController cycleDaysController = TextEditingController();

  // Function to show the custom bottom sheet
  // Function to show the custom bottom sheet// Function to show the custom bottom sheet
  void showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: context.read<GroupCubit>(), // تأكد من استخدام read() هنا
          child: CustomBottomSheet(
            nameController: nameController,
            membersController: membersController,
            dailyAmountController: dailyAmountController,
            cycleDaysController: cycleDaysController,
            isLoading: isLoading,
            onGroupAdded: (group) {
              bottomSheetContext.read<GroupCubit>().addGroup(group);
            },
          ),
        );
      },
    );
  }

  // Function to handle navigation to GroupDetailsScreen
  void navigateToGroupDetails(GroupModel group) {
    List<DateTime> paymentDates = [];
    Navigator.pushNamed(
      context,
      Routes.groupDetails,
      arguments: GroupDetailsArgs(group: group, paymentDates: paymentDates),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add new group',
          backgroundColor: ColorManager.mainColor,
          child: const Icon(Icons.add_circle, color: ColorManager.black),
          onPressed: () => showCustomBottomSheet(context),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
              child: Image.asset('assets/images/home_logo.jpeg'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(),
            ),
            Expanded(
              child: BlocBuilder<GroupCubit, GroupState>(
                builder: (context, state) {
                  if (state is GroupLoaded) {
                    if (state.groups.isEmpty) {
                      return const Center(
                        child: Text('لا توجد مجموعات مضافة حالياً.'),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: state.groups.length,
                      itemBuilder:
                          (context, index) => GroupItemWidget(
                            group: state.groups[index],
                            index: index,
                            onTap:
                                () =>
                                    navigateToGroupDetails(state.groups[index]),
                          ),
                    );
                  } else {
                    return const Center(
                      child: Text('لا توجد مجموعات مضافة حالياً.'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

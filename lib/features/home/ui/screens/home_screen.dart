import 'package:dorak_app/core/routing/routes.dart';
import 'package:dorak_app/core/theming/color_manager.dart';
import 'package:dorak_app/features/group_details/data/group_details_args.dart';
import 'package:dorak_app/features/home/data/model/group_model.dart';
import 'package:dorak_app/features/home/ui/widget/custom_bottom_sheet.dart';
import 'package:dorak_app/features/home/ui/widget/group_item_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  final List<GroupModel> groups = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController membersController = TextEditingController();
  final TextEditingController dailyAmountController = TextEditingController();
  final TextEditingController cycleDaysController = TextEditingController();

  // Function to show the custom bottom sheet
  void showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,

      context: context,
      builder: (context) {
        return CustomBottomSheet(
          nameController: nameController,
          membersController: membersController,
          dailyAmountController: dailyAmountController,
          cycleDaysController: cycleDaysController,
          isLoading: isLoading,
          onGroupAdded: (group) {
            setState(() {
              groups.add(group); // Add the group to the list
            });
          },
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
    return Scaffold(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: groups.length,
              itemBuilder:
                  (context, index) => GroupItemWidget(
                    group: groups[index],
                    index: index,
                    onTap:
                        () => navigateToGroupDetails(
                          groups[index],
                        ), // Navigate to details screen
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

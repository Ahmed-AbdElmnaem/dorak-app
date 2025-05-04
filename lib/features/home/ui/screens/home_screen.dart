import 'package:dorak_app/core/routing/routes.dart';
import 'package:dorak_app/core/theming/color_manager.dart';
import 'package:dorak_app/features/group_details/data/group_details_args.dart';
import 'package:dorak_app/features/home/data/model/group_model.dart';
import 'package:dorak_app/features/home/logic/groups_cubit.dart';
import 'package:dorak_app/features/home/ui/widget/custom_bottom_sheet.dart';
import 'package:dorak_app/features/home/ui/widget/group_item_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<void> _confirmDeleteGroup(
    BuildContext context,
    GroupModel group,
  ) async {
    bool isAuthenticated = await _localAuth.authenticate(
      localizedReason: 'من فضلك قم بتأكيد هويتك لحذف هذه الجمعية',
      options: AuthenticationOptions(stickyAuth: true),
    );

    if (isAuthenticated) {
      _deleteGroup(group, context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل في التحقق. لم يتم الحذف.')));
    }
  }

  Future<void> _deleteGroup(GroupModel group, BuildContext context) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      context.read<GroupsCubit>().deleteGroup(uid, group.id.toString());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تم حذف الجمعية بنجاح')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء حذف الجمعية: $e')));
    }
  }

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    Future.microtask(() {
      context.read<GroupsCubit>().fetchGroups(uid);
    });
  }

  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController membersController = TextEditingController();
  final TextEditingController dailyAmountController = TextEditingController();
  final TextEditingController cycleDaysController = TextEditingController();

  void showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: context.read<GroupsCubit>(),
          child: CustomBottomSheet(
            nameController: nameController,
            membersController: membersController,
            dailyAmountController: dailyAmountController,
            cycleDaysController: cycleDaysController,
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
      arguments: GroupDetailsArgs(
        //
        userId: FirebaseAuth.instance.currentUser!.uid,
        group: group, // تم تمرير الـ group بشكل صحيح
        paymentDates: group.calculatePaymentDates(),
      ),
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(),
          ),
          Expanded(
            child: BlocBuilder<GroupsCubit, GroupsState>(
              builder: (context, state) {
                if (state is GroupLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GroupDataLoaded) {
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
                              () => navigateToGroupDetails(state.groups[index]),
                          onDelete:
                              () => _confirmDeleteGroup(
                                context,
                                state.groups[index],
                              ), // ت
                        ),
                  );
                } else if (state is GroupDataError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('حدث خطأ غير معروف.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

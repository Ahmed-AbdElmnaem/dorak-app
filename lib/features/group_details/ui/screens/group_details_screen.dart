import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorak_app/features/group_details/data/repo/group_details_repository.dart';
import 'package:dorak_app/features/group_details/logic/cubit/group_details_cubit.dart';
import 'package:dorak_app/features/group_details/logic/cubit/group_details_state.dart';
import 'package:dorak_app/features/group_details/ui/widget/add_member_dialog.dart';
import 'package:dorak_app/features/group_details/ui/widget/group_info_card.dart';
import 'package:dorak_app/features/group_details/ui/widget/payments_data_table.dart';
import 'package:dorak_app/features/group_details/ui/widget/save_button.dart';
import 'package:dorak_app/features/home/data/model/group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

class GroupDetailsScreen extends StatefulWidget {
  final String userId;
  final List<DateTime> paymentDates;
  final GroupModel group;

  const GroupDetailsScreen({
    super.key,
    required this.userId,
    required this.paymentDates,
    required this.group,
  });

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  late final GroupDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = GroupDetailsCubit(
      GroupDetailsRepository(FirebaseFirestore.instance),
    );
    _loadMembers();
  }

  void _loadMembers() {
    _cubit.fetchGroupMembers(
      userId: widget.userId,
      groupId: widget.group.id.toString(),
      paymentDates: widget.group.calculatePaymentDates(),
    );
  }

  Future<void> _authenticateAndSave() async {
    final localAuth = LocalAuthentication();
    final isAvailable = await localAuth.canCheckBiometrics;

    if (!isAvailable) {
      _showSnackBar('البصمة غير متوفرة');
      return;
    }

    final authenticated = await localAuth.authenticate(
      localizedReason: 'يرجى تأكيد البصمة لحفظ التغييرات',
    );

    if (authenticated) {
      await _cubit.saveChanges(
        userId: widget.userId,
        groupId: widget.group.id.toString(),
        paymentDates: widget.paymentDates,
      );
    } else {
      _showSnackBar('فشل التحقق بالبصمة');
    }
  }

  void _showSnackBar(String message, {Color? color}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  void _onAddMemberPressed() {
    showAddMemberDialog(
      context: context,
      maxMembers: widget.group.membersCount,
      onAdd: (name) => _cubit.addMemberLocally(name),
      currentMembersCount:
          (_cubit.state as GroupDetailsLoaded?)?.members.length ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text('تفاصيل المجموعة: ${widget.group.name}'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add),
              tooltip: 'إضافة عضو  ',
              onPressed: _onAddMemberPressed,
            ),
          ],
        ),
        body: BlocConsumer<GroupDetailsCubit, GroupDetailsState>(
          listener: (context, state) {
            if (state is GroupDetailsError) {
              _showSnackBar(state.message, color: Colors.red);
            } else if (state is GroupDetailsUpdated) {
              _showSnackBar(state.message, color: Colors.green);
              _loadMembers();
            }
          },
          builder: (context, state) {
            if (state is GroupDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GroupDetailsLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GroupInfoCard(group: widget.group),
                    const SizedBox(height: 16),
                    PaymentsDataTable(
                      repository: GroupDetailsRepository(
                        FirebaseFirestore.instance,
                      ),

                      group: widget.group,
                      members: state.members,
                      paymentDates: widget.paymentDates,
                      payments: state.payments,
                      nameControllers:
                          state.members
                              .map((e) => TextEditingController(text: e.name))
                              .toList(),
                      onPaymentChanged: (memberIndex, paymentIndex, value) {
                        final member = state.members[memberIndex];
                        _cubit.updatePaymentLocally(
                          memberId: member.id,
                          paymentKey:
                              widget.paymentDates[paymentIndex]
                                  .toIso8601String(),
                          value: value,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    SaveButton(onPressed: _authenticateAndSave),
                  ],
                ),
              );
            }

            return const Center(child: Text('لا توجد بيانات.'));
          },
        ),
      ),
    );
  }
}
